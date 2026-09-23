# 概述

本项目通过 HTTP 调用百度 PCS 与百度网盘接口。所有请求共用同一套 `net/http/cookiejar`，由 Cookie 完成身份认证；极少数接口使用独立的请求签名。

## 身份认证

凭据按帐号持久化，字段定义见 `internal/pcsconfig/baidu.go`：

| 字段 | 用途 |
| :- | :- |
| `BDUSS` | 主认证凭据。所有请求以 Cookie 形式携带 |
| `STOKEN` | 网盘分享、转存等网页接口所需 |
| `SBOXTKN` | 以 Cookie 形式设置，当前无接口读取 |
| `BAIDUID` | 仅存储，不参与请求 |
| `PTOKEN` | 仅存储，不参与请求（`internal/pcsconfig/maniper.go` 中标注为未使用） |
| `COOKIES` | 完整 Cookie 串。当其中含 `STOKEN=` 且未单独提供 STOKEN 时，以整串替代其它凭据 |
| `AccessToken` | 仅旧版秒传接口使用，见下文 |

`login` 命令通过 `github.com/qjfoidnh/Baidu-Login` 完成用户名/密码/短信或邮箱验证/图片验证码流程，取得 BDUSS、SToken、PToken 与 Cookie 串（`internal/pcscommand/login.go`）。

装配为 HTTP 客户端的过程见 `internal/pcsconfig/baidu.go` 的 `Baidu.BaiduPCS()` 与 `baidupcs/baidupcs.go`：

- `NewPCS(appID, bduss)` 将 BDUSS 写入 Cookie jar；
- `SetStoken` / `SetSboxtkn` 追加对应 Cookie；
- 若使用完整 `COOKIES`，则 `NewPCSWithCookieStr` 解析整串，并把每个 Cookie 的 Domain 统一设为 `.baidu.com`。

Cookie 域固定为 `.baidu.com`。`baidupcs/publicsuffix.go` 把 `*.baidu.com` 的公有后缀视为 `com`，使 `baidu.com` 成为可注册域，Cookie 因而能下发给 `pcs.baidu.com`、`pan.baidu.com`、`d.pcs.baidu.com` 等子域。

### access_token

`access_token` 仅出现在旧版秒传接口 `pan.baidu.com/rest/2.0/xpan/file?method=create`（`baidupcs/prepare.go`）。它由 `setastoken` 命令设置，其余全部接口均不使用。

### app_id

- 网盘接口使用固定值 `250528`（常量 `PanAppID`）。
- 配置项 `AppID` 默认 `266719`（`internal/pcsconfig/pcsconfig.go`），用于 PCS 接口的 `app_id` 参数。

## 请求约定

### 主机与 URL 生成

| 生成器 | 主机与路径 | 说明 |
| :- | :- | :- |
| `generatePCSURL` | `pcs.baidu.com/rest/2.0/pcs/{sub}?app_id=&method=` | PCS 接口 |
| `generatePCSURL2` | `pan.baidu.com/rest/2.0/{sub}?method=` | 网盘旧版 REST 接口 |
| `generatePanURL` | `pan.baidu.com/api/{sub}` | 网盘网页接口 |

`pcs.baidu.com` 可被替换为其它 PCS 服务器地址（上传时从 `locateupload` 返回的服务器列表中选取）。HTTPS 开关由配置项控制。

### 方法与编码

- 查询类接口使用 GET，参数置于 query string。
- 提交类接口使用 POST，body 为 `multipart/form-data` 或 `application/x-www-form-urlencoded`，视具体接口而定。
- 表单字段名多为 `param`（承载 JSON）、`fidlist`、`fsidlist` 等，各接口单独说明。

### User-Agent

- PCS 类请求使用配置项 `PCSUA`。
- 网盘（pan）类请求使用配置项 `PanUA`，默认值为 `NetdiskUA`（一个 netdisk 客户端 UA 串）。
- 部分网页接口（分享转存）显式覆盖为浏览器 UA 或 netdisk UA。

## 响应与错误

三类接口返回的错误结构不同，程序分别解析：

| 接口类型 | 错误字段 | 解析位置 |
| :- | :- | :- |
| PCS | `error_code` / `error_msg` / `request_id` | `baidupcs/pcserror/pcserrorinfo.go` |
| pan | `errno` | `baidupcs/pcserror/panerrorinfo.go` |
| xpan | `errno` / `return_type` | `baidupcs/pcserror/xpanerrorinfo.go` |

错误码含义见 [errors.md](./errors.md)。

## 请求签名

部分接口在 query 中附加签名参数：

### locatedownload 设备签名

用于获取下载链接。由 BDUSS 与 uid 派生：

- `devuid` = `strings.ToUpper(hex(md5(bduss))) + "|0"`
- `rand` = `SHA1( hex(SHA1(bduss)) + uid + <固定盐> + time + devuid )`
- 附加参数：`time`、`rand`、`devuid`、`cuid`

实现见 `baidupcs/netdisksign/locatedownloadsign.go` 与 `devuid.go`。

### panhome 网页签名

用于 `pan.baidu.com/api/download`。先以无重定向客户端请求 `pan.baidu.com/disk/home`，从页面中正则提取 `sign1`/`sign3`/`timestamp`，经 `sign2` 算法（RC4 型流密码）计算并 base64 编码，得到 `sign`。签名缓存 1 小时；收到网盘错误码 112/113 时失效重取。实现见 `baidupcs/internal/panhome/` 与 `baidupcs/netdisksign/sign2.go`。

### 分享详情签名

`pan.baidu.com/share/surlinfoinrecord` 的 `sign` = `hex(md5(shareid + "_sharesurlinfo!@#"))`，见 `baidupcs/netdisksign/share_sign.go`。
