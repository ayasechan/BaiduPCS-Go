# 回收站 API

删除的文件进入回收站，可列出、还原、删除或清空。

## 列出回收站文件

- 方法：GET
- URL：`https://pan.baidu.com/api/recycle/list`

| 参数 | 说明 |
| :- | :- |
| `num` | 每页条目数，固定 `100` |
| `page` | 页码 |

## 还原文件/目录

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=restore&app_id=`
- Body：`multipart/form-data`，字段 `param` 承载 JSON：

```json
{"list":[{"fs_id":123},{"fs_id":456}]}
```

## 删除文件/目录

- 方法：POST
- URL：`https://pan.baidu.com/api/recycle/delete`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `fidlist` | 待删除 `fs_id` 列表，JSON 数组 |

## 清空回收站

- 方法：GET
- URL：`https://pcs.baidu.com/rest/2.0/pcs/file?method=delete&type=recycle&app_id=`
