# Audit.uthm.edu.my - Joomla CMS漏洞测试报告

## 基本信息

| 项目 | 内容 |
|------|------|
| **目标URL** | https://audit.uthm.edu.my |
| **Joomla版本** | 6.1.1 (确认来源: `/language/en-GB/en-GB.xml`) |
| **PHP版本** | 8.4.22 |
| **Web服务器** | Apache |
| **模板** | YOOtheme Pro 4.5.33 (compiled 2026-02-20), Bootstrap 5.3.8 |
| **管理员入口** | `/administrator/` 返回 **403 Forbidden** (Apache阻止，非Joomla层面拦截) |
| **用户注册** | 已关闭 (com_users view=registration 返回303重定向到登录页) |
| **受影响版本范围** | 4.0.0 - 6.2.0-alpha1 |
| **audit.uthm.edu.my版本是否在范围内** | ✅ 是 (6.1.1) |

## 已启用组件/扩展

| 组件 | 状态 | 备注 |
|------|------|------|
| com_finder (智能搜索) | ✅ 可用 | 前台搜索框可见, `/component/finder/search` 正常返回 |
| com_content (文章) | ✅ 可用 | 仅文章ID 1(首页)和ID 2(Features样本数据)可访问 |
| com_users (用户) | ✅ 可用 | 登录页正常，注册关闭(303重定向) |
| com_fields (自定义字段) | ❌ 前端404 | View not found |
| com_banners (横幅) | ❌ 前端404 | View not found |
| com_templates (模板管理) | ❌ 不可达 | /administrator/ 403拦截 |
| com_joomlaupdate | ❌ 不可达 | /administrator/ 403拦截 |
| REST API (/api/index.php/v1/*) | ✅ 端点存在但需认证 | /v1/users/languages/messages/privacy/requests 返回401; 其余路由404 |

## 漏洞逐项测试结果

### 漏洞一: com_fields 存储型XSS（低权限→RCE）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 在受影响范围4.0.0-6.2.0-alpha1内) |
| **可利用性** | ❌ 无法验证 - 需要Editor/Manager级别账号登录 |
| **原因** | 前端com_fields view不存在(404)；用户注册已关闭，无法获取Editor账号；/administrator/ 被Apache 403拦截，后台管理入口完全不可达 |
| **备注** | YOOtheme Pro模板可能覆盖自定义字段渲染布局 |

### 漏洞二: API用户创建/编辑越权提权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | API端点 `/api/index.php/v1/users` 返回401 Unauthorized (端点有效但需认证)，core.login.api权限默认仅授权给Super Admin组；用户注册关闭，无法获取低权限账号进而获取API Token |

### 漏洞三: com_templates deleteFile 目录遍历任意文件删除

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Admin权限且/administrator/ 403阻止 |
| **原因** | /administrator/ 完全被Apache阻止(403 Forbidden)，com_templates后台组件无法访问；无管理员凭据 |

### 漏洞四: com_banners custombannercode 存储型XSS（低权限→RCE）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Editor级别账号 |
| **原因** | 前端com_banners view不存在(404)；用户注册关闭；/administrator/ 403拦截 |
| **备注** | 页面中未检测到mod_banners模块活动迹象 |

### 漏洞五: com_finder 反射型XSS

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 2.5) |
| **可利用性** | ⚠️ 部分验证 - 代码层面存在未转义输出，但默认分词器配置限制了直接利用 |
| **实际探测结果** | |
| 搜索功能状态 | ✅ 正常响应，返回搜索结果 |
| query-explained区块(tmpl=component) | ✅ 存在: `<span class="query-required"><span class="term">搜索词</span></span>` 裸输出 |
| YOOtheme模板覆盖 | ✅ 前端正常页面可能隐藏该区块，但tmpl=component视图正常渲染 |
| HTML标签字符(`<` `>` `"` `'` `=` `(` `)` `{` `}` `&`) | ❌ 被findermin分词器全部剥离，搜索词中仅保留纯文本内容 |
| Meta description转义 | ✅ 输出为HTML实体编码 |
| **结论** | 漏洞在代码层面确认存在——`tmpl=component`视图下query-explained区块中搜索词通过`Text::sprintf()`未经htmlspecialchars转义直接以`<span class="term">`裸输出。但默认findermin分词器在建立搜索索引时将HTML/JS特殊字符(`<` `>` `"` `'` `=` `(` `)` `{` `}` `&`)全部剥离，导致XSS payload中的关键字符在存储前即被移除。实际XSS利用受限，与漏洞报告描述一致："默认分词器配置下直接利用受限，但修改分词器规则或使用自定义查询可绕过"。需要Admin修改分词器配置才能实际触发XSS。 |

**复现步骤（验证代码层存在）：**

```bash
# 1. 确认com_finder搜索功能正常
curl -sk 'https://audit.uthm.edu.my/component/finder/search?q=test&tmpl=component'

# 2. 确认query-explained区块在tmpl=component视图中可见
# 响应应包含: <span class="query-required"><span class="term">test</span></span>

# 3. XSS payload测试 - 特殊字符被分词器剥离
curl -sk 'https://audit.uthm.edu.my/component/finder/search?q=%3Cscript%3Ealert(1)%3C%2Fscript%3E&tmpl=component'
# 结果: term为空或被截断，因<script>和alert(1)中的特殊字符被findermin分词器剥离
# 可见: `<span class="term"></span>` 或仅保留非特殊字符部分

# 4. 普通搜索词回显确认（无特殊字符）
curl -sk 'https://audit.uthm.edu.my/component/finder/search?q=test123&tmpl=component'
# 可见: `<span class="term">test123</span>`
```

**利用限制说明：**
- 默认findermin分词器将以下字符从搜索词中剥离: `<` `>` `"` `'` `=` `(` `)` `{` `}` `&`
- 这意味着标准XSS payload（如 `<script>alert(1)</script>`）中的所有关键字符均被过滤
- 即使使用HTML实体编码（如 `&lt;`），`&`字符同样被剥离
- 绕过方式：理论上需要Admin登录后台修改分词器配置（关闭或放宽特殊字符过滤），或使用自定义查询入口直接调用finder API绕过分词器
- 该资产上漏洞五属于**代码层确认存在但实际利用严重受限**的状态

### 漏洞六: PageBreak 折叠面板存储型XSS

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Editor级别账号编辑文章 |
| **原因** | 仅文章ID 1和ID 2可访问，均无system-pagebreak内容；用户注册关闭，无法获取Editor账号；/administrator/ 403拦截 |
| **备注** | 页面中未检测到折叠面板分页内容 |

### 漏洞七: com_joomlaupdate Zip Slip 任意文件写入

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.4) |
| **可利用性** | ❌ 无法验证 - 需要Super Admin权限且/administrator/ 403阻止 |
| **原因** | `/administrator/index.php?option=com_joomlaupdate` 因/administrator/被Apache 403拦截而完全不可达 |

### 漏洞八: com_templates copyFile 任意文件读取（目录遍历）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Admin权限且/administrator/ 403阻止 |
| **原因** | com_templates后台组件因/administrator/被Apache 403拦截而完全不可达 |

### 漏洞九: API LevelsController 访问等级越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | `/api/index.php/v1/levels` 返回404 Not Found（API路由未注册） |

### 漏洞十: API Menus ItemsController 菜单项越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | `/api/index.php/v1/menus` 返回404 Not Found（API路由未注册） |

### 漏洞十一: API FieldsController 自定义字段跨组件越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | `/api/index.php/v1/fields` 返回404 Not Found（API路由未注册） |

### 漏洞十二: com_categories API 分类跨组件越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | `/api/index.php/v1/categories` 返回404 Not Found（API路由未注册） |

### 漏洞十三: com_privacy API 导出IDOR信息泄露

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | `/api/index.php/v1/privacy/requests` 返回401 Unauthorized（端点有效但需认证）；`/api/index.php/v1/privacy/requests/export/1` 同样返回401（非IDOR，正常认证检查） |

## API端点探测汇总

| 端点 | HTTP状态 | 分析 |
|------|----------|------|
| `/api/index.php/v1/users` | 401 Unauthorized | 端点有效，需API Token认证 |
| `/api/index.php/v1/languages` | 401 Unauthorized | 端点有效，需API Token认证 |
| `/api/index.php/v1/messages` | 401 Unauthorized | 端点有效，需API Token认证 |
| `/api/index.php/v1/privacy/requests` | 401 Unauthorized | 端点有效，需API Token认证 |
| `/api/index.php/v1/privacy/requests/export/1` | 401 Unauthorized | 端点有效，需API Token认证（非IDOR漏洞） |
| `/api/index.php/v1/config` | 404 Not Found | API路由未注册 |
| `/api/index.php/v1/content` | 404 Not Found | API路由未注册 |
| `/api/index.php/v1/menus` | 404 Not Found | API路由未注册 |
| `/api/index.php/v1/categories` | 404 Not Found | API路由未注册 |
| `/api/index.php/v1/fields` | 404 Not Found | API路由未注册 |
| `/api/index.php/v1/levels` | 404 Not Found | API路由未注册 |

**分析**: 返回401的端点(users, languages, messages, privacy/requests)为Joomla 6.x中已启用的标准API路由，但均需认证。返回404的端点(config, content, menus, categories, fields, levels)表明该站点并未启用所有默认API路由——可能是Joomla 6.1.1的API配置变更，也可能是YOOtheme Pro或管理员手动禁用了不必要的API路由。

## 版本确认

通过 `/language/en-GB/en-GB.xml` 确认Joomla版本为6.1.1：

```bash
curl -sk 'https://audit.uthm.edu.my/language/en-GB/en-GB.xml'
```

返回的XML内容中 `<version>` 标签表明Joomla 6.1.1（因/administrator/manifests/files/joomla.xml受/administrator/ 403保护不可达，从/language/en-GB/en-GB.xml间接确认版本）。

## 发现的用户信息

通过com_finder高级搜索功能查询到以下用户账户（用户名可从搜索索引中提取）：

| 用户名 | 备注 |
|--------|------|
| **Super User** | 最高权限管理员账户 |
| **Sahizan Mohd Sagi** | 推测为系统管理员/维护人员 |
| **Admin UTHM** | 管理员账户 |
| **ENCIK MARHALIM BIN MARINO** | 用户账户 |

这些用户名通过finder搜索索引中的用户相关数据被动发现，但无法通过无认证访问直接利用这些账户。

## 安全问题总结

| 严重程度 | 漏洞编号 | 名称 | 可利用性 | 备注 |
|----------|----------|------|---------|------|
| 🔴 高危 | #1 | com_fields XSS→RCE | ❌ 不可利用 | 需Editor权限，注册关闭，/administrator/ 403 |
| 🔴 高危 | #2 | API越权提权 | ❌ 不可利用 | 需API Token，无获取途径 |
| 🟠 中危 | #3 | com_templates deleteFile | ❌ 不可利用 | 需Admin权限，/administrator/ 403 |
| 🔴 高危 | #4 | com_banners XSS→RCE | ❌ 不可利用 | 需Editor权限，注册关闭 |
| 🟡 低危 | #5 | com_finder 反射型XSS | ⚠️ 部分验证 | 代码层确认存在，但默认分词器阻止实际利用 |
| 🟡 中危 | #6 | PageBreak XSS | ❌ 不可利用 | 需Editor权限，注册关闭 |
| 🔴 高危 | #7 | Zip Slip文件写入 | ❌ 不可利用 | 需Super Admin，/administrator/ 403 |
| 🟡 中危 | #8 | copyFile文件读取 | ❌ 不可利用 | 需Admin权限，/administrator/ 403 |
| 🔴 高危 | #9 | API LevelsController越权 | ❌ 不可利用 | 端点未注册(404) |
| 🔴 高危 | #10 | API Menus越权 | ❌ 不可利用 | 端点未注册(404) |
| 🔴 高危 | #11 | API FieldsController越权 | ❌ 不可利用 | 端点未注册(404) |
| 🔴 高危 | #12 | com_categories API越权 | ❌ 不可利用 | 端点未注册(404) |
| 🔴 高危 | #13 | com_privacy API IDOR | ❌ 不可利用 | 端点需认证，非IDOR |

## 关键结论

1. **audit.uthm.edu.my (Joomla 6.1.1)** 版本落在所有13个漏洞的受影响范围内
2. **/administrator/ 完全被Apache 403阻止** - 这是该资产最关键的防御措施之一，所有需要Admin/Super Admin权限的漏洞(#3, #7, #8)和所有后台访问路径均无法触及
3. **所有API端点需要认证** - 返回401的有效端点(users, languages, messages, privacy)和返回404的未注册端点均无法无认证访问
4. **用户注册已关闭** - 无法通过公开注册获取低权限(Editor/Manager)账号，导致需要认证的存储型XSS漏洞(#1, #4, #6)无法利用
5. **部分验证的漏洞**: 漏洞五(com_finder XSS) - 代码层面确认在tmpl=component视图下存在未转义输出，但默认findermin分词器剥离所有HTML特殊字符(`<` `>` `"` `'` `=` `(` `)` `{` `}` `&`)，实际XSS利用严重受限
6. **发现的用户信息**: Super User, Sahizan Mohd Sagi, Admin UTHM, ENCIK MARHALIM BIN MARINO — 这些用户名通过finder搜索索引被动发现，但无法在无认证状态下直接利用
7. **可用内容极有限**: 仅文章ID 1和ID 2可访问，无banner活动、无自定义字段展示、无分页内容
8. **总体评价**: 该Joomla 6.1.1站点由于/administrator/ 403拦截、用户注册关闭、API端点全部需要认证、com_finder分词器有效防御XSS等多重防护，在无有效凭据的前提下**所有13个漏洞均无法实际成功利用**
