# 文件管理 API

配额、目录列表、元信息、搜索，以及目录/文件的创建、移动、重命名、拷贝、删除。除目录列表走网盘网页接口外，其余均为 PCS 接口。

## 获取用户 UK

用于取得用户 `uk`，供下载、上传签名使用。

- 方法：GET
- URL：`https://pan.baidu.com/api/user/getinfo`

| 参数 | 说明 |
| :- | :- |
| `need_selfinfo` | 固定 `1` |

返回 `records` 数组，取其中 `uk`。

## 空间配额信息

获取当前用户空间配额。

- 方法：GET
- URL：`https://pcs.baidu.com/rest/2.0/pcs/quota?method=info&app_id=`

返回 `quota`（总配额，字节）与 `used`（已用，字节）。

## 列出目录下的文件

- 方法：GET
- URL：`https://pan.baidu.com/api/list`

| 参数 | 说明 |
| :- | :- |
| `dir` | 目录绝对路径 |
| `order` | 排序字段：`name` / `time` / `size` |
| `desc` | `1` 降序，`0` 升序 |
| `clienttype` | 固定 `0` |
| `num` | 每页条目数，上限 1000，超出或非正时取 1000 |
| `page` | 页码，从 1 开始 |

说明：本接口不使用 PCS 的 `file?method=list`。后者单次最多返回 1000 条且忽略 `num`/`page` 参数（`limit`/`start` 直接报 `param error`），无法获取超过 1000 条的目录。程序按 `num`/`page` 翻页拉取全量，并对 `fs_id` 去重。

## 获取文件/目录的元信息（批量）

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=meta&app_id=`
- Body：`multipart/form-data`，字段 `param` 承载 JSON：

```json
{"list":[{"path":"/绝对/路径"},{"path":"/另一个/路径"}]}
```

## 搜索文件

- 方法：GET
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=search&app_id=`

| 参数 | 说明 |
| :- | :- |
| `path` | 搜索起始目录 |
| `wd` | 关键词 |
| `re` | 是否递归：`1` 是，`0` 否 |

## 创建目录

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=mkdir&app_id=`

| 参数 | 说明 |
| :- | :- |
| `path` | 目录绝对路径 |

## 移动 / 重命名

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=move&app_id=`
- Body：`multipart/form-data`，字段 `param` 承载 JSON：

```json
{"list":[{"from":"/源路径","to":"/目标路径"}]}
```

重命名为在同一目录内移动（`from` 与 `to` 仅文件名不同）。

## 拷贝

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=copy&app_id=`
- Body：`multipart/form-data`，字段 `param` 格式同“移动/重命名”。

## 删除（批量）

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=delete&app_id=`
- Body：`multipart/form-data`，字段 `param` 承载 JSON：

```json
{"list":[{"path":"/待删/路径"},{"path":"/待删/另一个"}]}
```

被删除的文件进入回收站，相关接口见 [recycle_api.md](./recycle_api.md)。
