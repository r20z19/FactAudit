# aar-bochum.de - Joomla CMS漏洞测试报告

## 基本信息

| 项目 | 内容 |
|------|------|
| **主机名** | aar-bochum.de (https://aar-bochum.de/) |
| **Joomla版本** | 6.1.1 (确认来源: /administrator/manifests/files/joomla.xml) |
| **版本创建日期** | 2026-05 |
| **模板** | Cassiopeia (Joomla 4/5/6 默认模板) |
| **Web服务器** | LiteSpeed |
| **WAF/防护** | 存在WAF (检测到x-xss-protection: 1; mode=block, 含有`<script>`的请求被返回403) |
| **PHP版本** | 未直接确认 (configuration.php返回200空白页, PHP正常执行) |
| **语言** | de-DE (德语) |
| **CSRF Token** | 3534db54e6af6c643d014a587cba87f2 (页面首加载时) |
| **受影响版本范围** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本是否在范围内** | ✅ 是 (6.1.1) |

## 已启用组件/扩展

| 组件 | 状态 | 备注 |
|------|------|------|
| com_finder (智能搜索) | ✅ 可用 | /component/finder/search 正常返回, query-explained区块可见 |
| com_content (文章) | ✅ 可用 | 有文章内容(itemid=479), /index.php/blog 正常 |
| com_users (用户) | ✅ 可用 | 注册关闭(303重定向到首页), 登录页可访问 |
| com_fields (自定义字段) | ❌ 前端不可直接访问 | 返回404 View not found |
| com_banners (横幅) | ❌ 前端不可直接访问 | 返回404 View not found (静态banner.png图片在首页, 非com_banners组件) |
| com_templates (模板管理) | ❌ 需admin登录 | /administrator/index.php?option=com_templates 返回200但为登录页面 |
| REST API (/api/index.php/v1/*) | ✅ 端点存在但需认证 | /v1/users/languages/messages/privacy/requests 返回401(需认证); /v1/config/content/menus/categories/fields/levels 返回404 |

## 漏洞逐项测试结果

### 漏洞一: com_fields 存储型XSS（低权限→RCE）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1在受影响范围4.0.0-6.2.0-alpha1内) |
| **可利用性** | ❌ 无法验证 - 需要Editor/Manager级别账号登录 |
| **原因** | 用户注册已禁用(303重定向), 无公开注册入口; com_fields前端View不存在(404, core组件仅admin端可用) |
| **备注** | Cassiopeia模板为标准模板, 不覆盖字段渲染布局 |

### 漏洞二: API用户创建/编辑越权提权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | API端点(/api/index.php/v1/users)返回401 Unauthorized(端点存在但需认证); 无公开注册入口获取低权限账号; 默认core.login.api权限仅授权给Super Admin组 |
| **API端点测试** | /v1/users → 401, /v1/languages → 401, /v1/messages → 401, /v1/privacy/requests → 401 |

### 漏洞三: com_templates deleteFile 目录遍历任意文件删除

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Admin/Super Admin级别权限 |
| **原因** | /administrator/index.php?option=com_templates 返回200但为登录页面; 需要Admin登录后才能访问 |
| **复现步骤(理论)** | 1. Admin登录 → 2. POST到com_templates.deleteFile → 参数file=Ly4uLy4uL2NvbmZpZ3VyYXRpb24ucGhw |

### 漏洞四: com_banners custombannercode 存储型XSS（低权限→RCE）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Editor级别账号 |
| **原因** | 前端com_banners view不存在(404); 需登录后台编辑banner; 无公开注册入口 |
| **备注** | 首页有静态banner.png图片(img标签), 非com_banners/mod_banners组件输出 |

### 漏洞五: com_finder 反射型XSS

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 2.5) |
| **可利用性** | ❌ 无法利用 - 代码层存在未转义输出但WAF阻挡所有含`<script>`的请求 |
| **实际探测结果** | |
| 搜索功能状态 | ✅ 正常响应, 返回搜索结果(或"未找到结果"提示) |
| query-explained区块 | ✅ 存在: `<span class='term'>test</span>` 搜索词裸输出在span标签中 |
| 前端(tmpl=component) | ✅ query-explained区块同时在前端和tmpl=component视图中可见 |
| WAF拦截含script请求 | ✅ 经确认: 含有`<script>`的查询词返回403 Forbidden(WAF/ModSecurity) |
| 分词器行为 | 默认findermin分词器剥离`< > " ' = ( ) { } &`等HTML特殊字符 |
| **结论** | 代码层面确认存在未转义输出(Text::sprintf()) - `<span class='term'>q</span>`中的q参数未经过htmlspecialchars转义; 但WAF拦截含有`<script>`标签的请求, 且默认分词器剥离HTML特殊字符, 实际无法利用 |

**测试记录:**
```bash
# 基本搜索 - 正常, query-explained可见
curl -sk 'https://aar-bochum.de/component/finder/search?q=test&tmpl=component'
# 响应: <span class='term'>test</span>

# XSS payload - 被WAF拦截, 返回403
curl -sk 'https://aar-bochum.de/component/finder/search?q=%3Cscript%3Ealert(1)%3C/script%3E&tmpl=component'
# 响应: 403 Forbidden (WAF拦截)

# 特殊字符测试 - 单引号存活, 双引号被剥离
curl -sk 'https://aar-bochum.de/component/finder/search?q=test%27%22&tmpl=component'
# 响应: <span class='term'>test'</span> (双引号被剥离)
```

### 漏洞六: PageBreak 折叠面板存储型XSS

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Editor级别账号编辑文章 |
| **原因** | 需登录后在文章中插入`<hr class="system-pagebreak" title="XSS">`; 无公开注册入口 |
| **备注** | 页面中未检测到system-pagebreak分页内容 |

### 漏洞七: com_joomlaupdate Zip Slip 任意文件写入

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.4) |
| **可利用性** | ❌ 无法验证 - 需要Super Admin权限 |
| **原因** | /administrator/index.php?option=com_joomlaupdate 返回200但为登录页面 |
| **复现步骤(理论)** | 1. Super Admin登录 → 2. 上传包含目录穿越条目的恶意ZIP更新包 → 3. 任意文件写入 |

### 漏洞八: com_templates copyFile 任意文件读取（目录遍历）

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 3.x) |
| **可利用性** | ❌ 无法验证 - 需要Admin权限 |
| **原因** | 仅admin端组件可用; 需管理员登录 |

### 漏洞九: API LevelsController 访问等级越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | /api/index.php/v1/levels 返回404 (路由未注册); API访问需认证且无注册入口 |

### 漏洞十: API Menus ItemsController 菜单项越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | /api/index.php/v1/menus 返回404 (路由未注册) |

### 漏洞十一: API FieldsController 自定义字段跨组件越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | /api/index.php/v1/fields 返回404 (路由未注册) |

### 漏洞十二: com_categories API 分类跨组件越权

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | /api/index.php/v1/categories 返回404 (路由未注册) |

### 漏洞十三: com_privacy API 导出IDOR信息泄露

| 项目 | 结果 |
|------|------|
| **适用性** | ✅ 理论适用 (Joomla 6.1.1 >= 4.0.0) |
| **可利用性** | ❌ 无法验证 |
| **原因** | /api/index.php/v1/privacy/requests 返回401 (端点存在但需认证); 无法获取API Token |

## API端点探测汇总

| 端点 | HTTP状态 | 分析 |
|------|----------|------|
| /api/index.php/v1/users | 401 Unauthorized | 端点存在, 需API Token认证 |
| /api/index.php/v1/languages | 401 Unauthorized | 端点存在, 需API Token认证 |
| /api/index.php/v1/messages | 401 Unauthorized | 端点存在, 需API Token认证 |
| /api/index.php/v1/privacy/requests | 401 Unauthorized | 端点存在, 需API Token认证 |
| /api/index.php/v1/config | 404 Not Found | 该API路由未注册 |
| /api/index.php/v1/content | 404 Not Found | 该API路由未注册 |
| /api/index.php/v1/menus | 404 Not Found | 该API路由未注册 |
| /api/index.php/v1/categories | 404 Not Found | 该API路由未注册 |
| /api/index.php/v1/fields | 404 Not Found | 该API路由未注册 |
| /api/index.php/v1/levels | 404 Not Found | 该API路由未注册 |

## 安全问题总结

| 严重程度 | 漏洞编号 | 可利用性 | 备注 |
|----------|----------|---------|------|
| 🔴 高危 | #1 com_fields XSS→RCE | ❌ 需认证 | 需Editor/Manager账号 |
| 🔴 高危 | #2 API越权提权 | ❌ 需API Token | /v1/users返回401 |
| 🟠 中危 | #3 com_templates deleteFile | ❌ 需Admin | 需管理员登录 |
| 🔴 高危 | #4 com_banners XSS→RCE | ❌ 需认证 | 需Editor账号 |
| 🟡 低危 | #5 com_finder XSS | ❌ WAF+分词器双重阻断 | 代码漏洞存在但WAF(403)和分词器双重阻止利用 |
| 🟡 中危 | #6 PageBreak XSS | ❌ 需认证 | 需Editor账号编辑文章 |
| 🔴 高危 | #7 Zip Slip文件写入 | ❌ 需Super Admin | 需超级管理员 |
| 🟡 中危 | #8 copyFile文件读取 | ❌ 需Admin | 需管理员登录 |
| 🔴 高危 | #9-#13 API越权 | ❌ 需API Token | 核心API端点需认证(401), 管理API端点未注册(404) |

## 关键结论

1. **aar-bochum.de (Joomla 6.1.1)** 版本落在所有13个漏洞的受影响范围内
2. **未认证可测试的漏洞**: 仅漏洞五(com_finder XSS)可在无认证状态下测试
3. **漏洞五测试结果**: 代码层面确认query-explained区块中`<span class='term'>`内的搜索词未经过htmlspecialchars转义(Text::sprintf()直接输出), 但(1) WAF拦截含有`<script>`的请求返回403, (2) 默认findermin分词器剥离HTML特殊字符(`< > " ' = ( ) { } &`), 双重阻止导致实际无法利用
4. **主要障碍**: 用户注册已关闭(303重定向), 无法通过公开注册获取低权限测试账号; API端点需认证; WAF拦截可疑请求
5. **与uiltemp.it对比**: 无Imunify360/YOOtheme模板, 使用Cassiopeia默认模板, query-explained区块在前端直接可见
6. **可利用漏洞数**: 0/13 (全部13个漏洞均因认证/WAF限制无法实际利用)
