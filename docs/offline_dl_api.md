# 离线下载 API

离线下载使用 `pan.baidu.com/rest/2.0/services/cloud_dl`，以 `method` 区分操作。支持 http/https/ftp/电驴/磁力链协议。

## 添加任务

- 方法：POST
- URL：`https://pan.baidu.com/rest/2.0/services/cloud_dl?method=add_task`

| 参数 | 说明 |
| :- | :- |
| `app_id` | `250528` |
| `task_from` | 固定 `0` |
| `selected_idx` | 固定 `1` |
| `save_path` | 保存目录 |
| `source_url` | 下载源地址 |

## 精确查询任务

- 方法：GET
- URL：`https://pan.baidu.com/rest/2.0/services/cloud_dl?method=query_task`

| 参数 | 说明 |
| :- | :- |
| `app_id` | `250528` |
| `op_type` | 固定 `1` |
| `task_ids` | 任务 ID，多个以逗号分隔 |

## 查询任务列表

- 方法：POST
- URL：`https://pan.baidu.com/rest/2.0/services/cloud_dl?method=list_task`

| 参数 | 说明 |
| :- | :- |
| `need_task_info` | 固定 `1` |
| `status` | 固定 `255`（全部状态） |
| `start` | 起始位置，固定 `0` |
| `limit` | 数量上限，固定 `1000` |
| `app_id` | `250528` |

## 取消 / 删除任务

- 方法：POST
- URL：`https://pan.baidu.com/rest/2.0/services/cloud_dl?method=cancel_task` 或 `...?method=delete_task`

| 参数 | 说明 |
| :- | :- |
| `app_id` | `250528` |
| `task_id` | 任务 ID |

## 清空任务记录

- 方法：POST
- URL：`https://pan.baidu.com/rest/2.0/services/cloud_dl?method=clear_task`
