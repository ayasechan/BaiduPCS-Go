# 下载 API

下载优先通过 `locatedownload` 或网盘网页接口获取直链，再对直链发起下载；亦保留 PCS 直下与流式下载两种模式。

## 获取下载链接（locatedownload）

默认的取链方式。

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload`
- Body：空
- 附加签名：`time`、`rand`、`devuid`、`cuid`（见 [overview.md](./overview.md#locatedownload-设备签名)）

| query 参数 | 说明 |
| :- | :- |
| `ant` | `1` |
| `check_blue` | `1` |
| `es` / `esl` | `1` |
| `app_id` | `250528` |
| `path` | 目标绝对路径 |
| `ver` | `4.0` |
| `clienttype` | `17` |
| `channel` | `0` |
| `apn_id` | `1_0` |
| `freeisp` | `0` |
| `queryfree` | `0` |
| `use` | `0` |

返回 `urls` 数组，每项含 `url` 与 `encrypt`；程序仅使用 `encrypt == 0` 的非加密链接。

## 获取下载链接（网盘网页接口）

- 方法：POST
- URL：`https://pan.baidu.com/api/download`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `sign` | panhome 网页签名（见 [overview.md](./overview.md#panhome-网页签名)） |
| `timestamp` | 签名时间戳 |
| `fidlist` | 文件 `fs_id` 列表，JSON 数组 |

返回 `dlink` 数组，每项含 `dlink` 与 `fs_id`。签名缓存 1 小时；返回错误码 `112`（页面已过期）或 `113`（签名错误）时签名失效并重取。

## 直下

- 方法：GET
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=download`

| 参数 | 说明 |
| :- | :- |
| `path` | 目标绝对路径 |

## 流式下载

- 方法：GET
- URL：`https://pcs.baidu.com/rest/2.0/pcs/stream?method=download`

| 参数 | 说明 |
| :- | :- |
| `path` | 目标绝对路径 |
