# 上传 API

上传分三个阶段：先以秒传接口 `pan.baidu.com/api/precreate` 做预创建（命中则秒传成功），未命中再由 `pcs.baidu.com/.../superfile2` 逐片上传，最后以 `pan.baidu.com/api/create` 合并。另有旧版秒传接口。

## 分片大小

由文件大小决定（`internal/pcsfunctions/pcsupload/utils.go`）：

| 文件大小 | 分片大小 |
| :- | :- |
| < 8 GB | 4 MB |
| 8 GB ~ 32 GB | 16 MB |
| >= 32 GB | 64 MB |

单个文件上限 128 GB。

## 秒传 / 预创建（precreate）

- 方法：POST
- URL：`https://pan.baidu.com/api/precreate`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `path` | 目标绝对路径 |
| `target_path` | 目标所在目录（以 `/` 结尾） |
| `size` | 文件总大小 |
| `data_offset` | 随机子片段在文件中的偏移 |
| `data_length` | 子片段长度 |
| `data_content` | 子片段内容的 base64（去尾部 `=`） |
| `data_time` / `local_mtime` / `local_ctime` | 时间戳 |
| `content-md5` | 整文件 MD5（小写） |
| `slice-md5` | 前 256 KB 的 MD5（小写） |
| `block_list` | 各分片的 MD5 列表，JSON 数组 |
| `rtype` | 重名策略：`2` 跳过，`3` 覆盖 |
| `isdir` | 固定 `0` |
| `autoinit` | 固定 `1` |
| `checkexist` | 固定 `0` |
| `mode` | 固定 `1` |

`data_offset` 由 `md5(uk + contentMD5 + dataTime)` 的前 8 个十六进制字符对 `文件大小 - 子片段长度 + 1` 取模得到；子片段长度固定 4 KB。见 `baidupcs/upload.go` 与 `internal/pcsfunctions/pcsupload/utils.go`。

返回 `return_type`：`2` 表示秒传命中（上传完成），`1` 表示需继续分片上传，并返回 `uploadid`。

## 跳过秒传的预创建

`--norapid` 时仅做预创建，不携带校验和，用于直接获得 `uploadid` 并跳过秒传检测。

- 方法：POST
- URL：`https://pan.baidu.com/api/precreate?app_id=250528&channel=1&web=1`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `path` | 目标绝对路径 |
| `target_path` | 目标所在目录（以 `/` 结尾） |
| `local_mtime` | 时间戳 |
| `rtype` | 重名策略：`2` 跳过，`3` 覆盖 |
| `block_list` | 固定的伪 block 列表 |
| `autoinit` | 固定 `1` |

## 分片上传

- 方法：POST
- URL：`https://pcs.baidu.com/rest/2.0/pcs/superfile2?method=upload`
- Body：`multipart/form-data`

| 参数 | 位置 | 说明 |
| :- | :- | :- |
| `type` | query | 固定 `tmpfile` |
| `path` | query | 目标绝对路径 |
| `partseq` | query | 分片序号，从 0 开始 |
| `partoffset` | query | 分片在文件中的偏移 |
| `uploadid` | query | 预创建返回的上传 ID |
| `vip` | query | 固定 `1` |
| `uploadedfile` | body | 分片内容，文件字段名 |

返回该分片的 `md5`。上传服务器地址 `pcs.baidu.com` 从 `locateupload` 返回的服务器列表中随机选取，每上传若干分片更换一次。

## 合并分片

- 方法：POST
- URL：`https://pan.baidu.com/api/create`
- Content-Type：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `uploadid` | 上传 ID |
| `path` | 目标绝对路径 |
| `size` | 文件总大小 |
| `isdir` | 固定 `0` |
| `rtype` | 重名策略：`2` 跳过，`3` 覆盖 |
| `block_list` | 各分片 MD5 列表，JSON 数组 |
| `target_path` | 目标所在目录 |

## 旧版秒传

- 方法：POST
- URL：`https://pan.baidu.com/rest/2.0/xpan/file?method=create&access_token=`
- Body：`application/x-www-form-urlencoded`

| 参数 | 说明 |
| :- | :- |
| `block_list` | 整文件 MD5 列表，JSON 数组 |
| `path` | 目标绝对路径 |
| `size` | 文件大小 |
| `isdir` | 固定 `0` |
| `rtype` | 重名策略：`2` 跳过，`3` 覆盖 |

此为唯一使用 `access_token` 的接口，需先以 `setastoken` 设置。

## 单文件上传（未使用）

`pcs.baidu.com/rest/2.0/pcs/file?method=upload`（query 含 `path`、`ondup`）在代码中保留但未被调用。

## 重名策略

| 策略 | rtype | 行为 |
| :- | :- | :- |
| `skip` | 2 | 目标已存在同名文件时跳过 |
| `overwrite` | 3 | 覆盖同名文件 |
| `rsync` | 3 | 目标存在且大小相同则跳过，否则覆盖 |
