# 分享与转存 API

分享使用 `pan.baidu.com/share/*` 接口；转存通过访问分享页、校验提取码、列出分享项、提交转存四步完成。转存依赖登录凭据中包含网盘 `STOKEN`。

## 获取 bdstoken

分享、转存所需的 `bdstoken` 亦可由此接口取得。

- 方法：GET
- URL：`https://pan.baidu.com/api/gettemplatevariable`

| 参数 | 说明 |
| :- | :- |
| `clienttype` | 固定 `0` |
| `app_id` | 见 [overview.md](./overview.md#app_id) |
| `fields` | 固定 `["bdstoken"]` |

返回 `result.bdstoken`。

## 创建分享

- 方法：POST
- URL：`https://pan.baidu.com/share/pset`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `path_list` | 待分享路径列表，JSON 数组 |
| `schannel` | 固定 `4` |
| `channel_list` | 固定 `[]` |
| `period` | 有效期（天） |
| `pwd` | 提取码 |
| `share_type` | 固定 `9` |

## 取消分享

- 方法：POST
- URL：`https://pan.baidu.com/share/cancel`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `shareid_list` | 分享 ID 列表，JSON 数组 |

## 列出分享

- 方法：GET
- URL：`https://pan.baidu.com/share/record`

| 参数 | 说明 |
| :- | :- |
| `page` | 页码 |
| `desc` | 固定 `1` |
| `order` | 固定 `time` |

## 获取分享详情

- 方法：GET
- URL：`https://pan.baidu.com/share/surlinfoinrecord`

| 参数 | 说明 |
| :- | :- |
| `shareid` | 分享 ID |
| `sign` | `hex(md5(shareid + "_sharesurlinfo!@#"))` |

## 转存

转存流程按顺序调用下列接口。

### 1. 访问分享页

- 方法：GET
- URL：`https://pan.baidu.com/s/{featurestr}`

从页面内容中解析出 `bdstoken`、`uk`、`share_uk`、`shareid`。页面含 `error-404` 表示不存在，含 `platform-non-found` 表示链接已失效；未解析到 `loginstate` 通常意味着登录凭据缺少 `STOKEN`。

### 2. 校验提取码

- 方法：POST
- URL：`https://pan.baidu.com/share/verify`

| 参数 | 位置 | 说明 |
| :- | :- | :- |
| `shareid` | query | 分享 ID |
| `time` | query | 当前毫秒时间戳 |
| `clienttype` | query | 固定 `1` |
| `uk` | query | 分享者 uk（`share_uk`） |
| `pwd` | body | 提取码 |
| `vcode` | body | 固定 `null` |
| `vcode_str` | body | 固定 `null` |
| `bdstoken` | body | 分享页解析所得 |

返回 `randsk`。

### 3. 列出分享项

- 方法：GET
- URL：`https://pan.baidu.com/share/list`

| 参数 | 说明 |
| :- | :- |
| `app_id` | `250528` |
| `channel` | `chunlei` |
| `clienttype` | `0` |
| `web` | `5` |
| `root` | `1` |
| `shorturl` | 分享标识 |
| `bdstoken` | 分享页解析所得 |

返回 `list`，每项含 `server_filename` 与 `fs_id`。

### 4. 提交转存

- 方法：POST
- URL：`https://pan.baidu.com/share/transfer`

| 参数 | 位置 | 说明 |
| :- | :- | :- |
| `app_id` | query | `250528` |
| `channel` | query | `chunlei` |
| `clienttype` | query | `0` |
| `web` | query | `1` |
| `shareid` | query | 分享 ID |
| `from` | query | 分享者 uk |
| `bdstoken` | query | 分享页解析所得 |
| `fsidlist` | body | 待转存 `fs_id` 列表，JSON 数组 |
| `path` | body | 转存目标目录 |
