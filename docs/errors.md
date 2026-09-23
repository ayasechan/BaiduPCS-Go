# 错误码

程序按接口类型解析三类错误结构，见 [overview.md](./overview.md#响应与错误)。

## PCS error_code

PCS 接口返回 `error_code`（部分由程序改写为更明确的中文提示，标注于备注）。

| HTTP状态码 | 错误码 | 错误信息 | 备注 |
| :- | -: | :- | :- |
| 200 | 0 | no error | 没有错误 |
| 400 | 3 | Unsupported open api | 不支持此接口 |
| 403 | 4 | No permission to do this operation | 没有权限执行此操作 |
| 403 | 5 | Unauthorized client IP address | IP未授权 |
| 503 | 31001 | db query error | 数据库查询错误 |
| 503 | 31002 | db connect error | 数据库连接错误 |
| 503 | 31003 | db result set is empty | 数据库返回空结果 |
| 503 | 31021 | network error | 网络错误 |
| 503 | 31022 | can not access server | 暂时无法连接服务器 |
| 400 | 31023 | param error | 输入参数错误 |
| 400 | 31024 | app id is empty | app id为空 |
| 503 | 31025 | bcs error | 后端存储错误 |
| 403 | 31041 | bduss is invalid | 用户的cookie不是合法的百度cookie |
| 403 | 31042 | user is not login | 用户未登陆 |
| 403 | 31043 | user is not active | 用户未激活 |
| 403 | 31044 | user is not authorized | 用户未授权 |
| 403 | 31045 | user not exists | 帐号登录状态过期, 请重新登录 |
| 403 | 31046 | user already exists | 用户已经存在 |
| 400 | 31061 | file already exists | 文件已存在 |
| 400 | 31062 | file name is invalid | 文件名非法 |
| 400 | 31063 | file parent path does not exist | 文件父目录不存在 |
| 403 | 31064 | file is not authorized | 无权访问此文件 |
| 400 | 31065 | directory is full | 目录已满 |
| 403 | 31066 | file does not exist | 文件或目录不存在 |
| 503 | 31067 | file deal failed | 文件处理出错 |
| 503 | 31068 | file create failed | 文件创建失败 |
| 503 | 31069 | file copy failed | 文件拷贝失败 |
| 503 | 31070 | file delete failed | 文件删除失败 |
| 503 | 31071 | get file meta failed | 不能读取文件元信息 |
| 503 | 31072 | file move failed | 文件移动失败 |
| 503 | 31073 | file rename failed | 文件重命名失败 |
| 404 | 31079 | File md5 not found, you should use upload API to upload the whole file. | 秒传文件失败 |
| 503 | 31081 | superfile create failed | superfile创建失败 |
| 503 | 31082 | superfile block list is empty | superfile 块列表为空 |
| 503 | 31083 | superfile update failed | superfile 更新失败 |
| 503 | 31101 | tag internal error | tag系统内部错误 |
| 503 | 31102 | tag param error | tag参数错误 |
| 503 | 31103 | tag database error | tag系统错误 |
| 403 | 31110 | access denied to set quota | 未授权设置此目录配额 |
| 400 | 31111 | quota only sopport 2 level directories | 配额管理只支持两级目录 |
| 400 | 31112 | exceed quota | 超出配额 |
| 403 | 31113 | the quota is bigger than one of its parent directories | 配额不能超出目录祖先的配额 |
| 403 | 31114 | the quota is smaller than one of its sub directories | 配额不能比子目录配额小 |
| 503 | 31141 | thumbnail failed, internal error | 请求缩略图服务失败 |
| 401 | 110 | Access token invalid or no longer valid | Access Token不正确或者已经过期 |
| 400 | 31201 | signature error | 签名错误 |
| 404 | 31202 | object not exists | 文件不存在 |
| 400 | 31203 | acl put error | 设置acl失败 |
| 400 | 31204 | acl query error | 请求acl验证失败 |
| 400 | 31205 | acl get error | 获取acl失败 |
| 404 | 31206 | acl get error | acl不存在 |
| 400 | 31207 | bucket already exists | bucket已存在 |
| 400 | 31208 | bad request | 用户请求错误 |
| 500 | 31209 | baidubs internal error | 服务器错误 |
| 501 | 31210 | not implement | 服务器不支持 |
| 403 | 31211 | access denied | 禁止访问 |
| 503 | 31212 | service unavailable | 服务不可用 |
| 503 | 31213 | service unavailable | 重试出错 |
| 503 | 31214 | put object data error | 上传文件data失败 |
| 503 | 31215 | put object meta error | 上传文件meta失败 |
| 503 | 31216 | get object data error | 下载文件data失败 |
| 503 | 31217 | get object meta error | 下载文件meta失败 |
| 403 | 31218 | storage exceed limit | 容量超出限额 |
| 403 | 31219 | request exceed limit | 请求数超出限额 |
| 403 | 31220 | transfer exceed limit | 流量超出限额 |
| 500 | 31298 | the value of KEY[VALUE] in pcs response headers is invalid | 服务器返回值KEY非法 |
| 500 | 31299 | no KEY in pcs response headers | 服务器返回值KEY不存在 |
| - | 31363 | block miss in superfile2 | 上传状态过期, 需重新上传 |
| - | 114514 | - | skip 策略下目标位置存在同名文件（程序自定义） |
| - | 1919810 | - | rsync 策略下目标位置存在相同文件（程序自定义） |

## pan errno

pan 接口返回 `errno`，含义由 `baidupcs/pcserror/panerrorinfo.go` 的 `FindPanErr` 定义。

| errno | 含义 |
| -: | :- |
| 0 | 成功 |
| -1 | 分享了违反法律法规的文件，分享功能被禁用 |
| -2 | 用户不存在 |
| -3 | 文件不存在 |
| -4 | 登录信息有误 |
| -5 | host_key和user_key无效 |
| -6 | 请重新登录 |
| -7 | 该分享已删除或已取消 |
| -8 | 已存在同名文件 |
| -9 | 文件不存在 |
| -10 | 分享外链已达上限100000条 |
| -11 | 验证cookie无效 |
| -12 | 访问密码错误 |
| -14 | 短信分享每天限制20条 |
| -15 | 邮件分享每天限制20封 |
| -16 | 该文件已限制分享 |
| -17 | 文件分享超过限制 |
| -19 | 需要输入验证码 |
| -21 | 分享已取消或分享信息无效 |
| -30 | 文件已存在 |
| -31 | 文件保存失败 |
| -33 | 一次支持操作999个 |
| -62 | 可能需要输入验证码 |
| -70 | 分享文件中包含病毒 |
| 2 | 请稍后再试, 或更换保存路径 |
| 3 | 未登录或帐号无效 |
| 4 | 存储出错 |
| 105 | 链接错误, 未找到文件 |
| 108 | 文件名有敏感词 |
| 110 | 分享次数超出限制 |
| 112 | 页面已过期, 请刷新后重试 |
| 113 | 签名错误 |
| 114 | 当前任务不存在, 保存失败 |
| 115 | 该文件禁止分享 |
| 132 | 帐号存在安全风险, 需先进行安全验证 |
| 9019 | accesstoken未设置或过期 |

转存流程另有 `8001`（已触发验证, 请稍后再试）与 `12`（转存项错误）等，见 `baidupcs/transfer.go`。

## xpan errno / return_type

xpan 接口（`xpan/file`）返回 `errno` 与 `return_type`。预创建场景下 `return_type == 2` 表示秒传命中。程序对未知组合统一下发"错误类型: N"提示，见 `baidupcs/pcserror/xpanerrorinfo.go`。
