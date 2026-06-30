# 漏洞测试报告: somministrazione.uiltemp.it

## 基本信息

| 项目 | 内容 |
|------|------|
| **目标URL** | https://somministrazione.uiltemp.it |
| **Joomla版本** | 4.3.4 (通过 `/administrator/manifests/files/joomla.xml` 确认) |
| **服务器** | LiteSpeed / openresty (WAF: Imunify360 bot-protection), TLS 1.3 |
| **IP** | 185.201.65.137 |
| **PHP版本** | 未知(无法直接检测) |
| **前端模板** | Cassiopeia (Joomla 4默认模板) |
| **语言** | it-IT (意大利语) |
| **管理员入口** | `/administrator/` 返回200, 登录表单正常 |
| **用户注册** | 已关闭 (com_users view=registration 返回303重定向) |
| **REST API** | 存在, `/api/index.php/v1/users` 等端点返回401需认证 |

## 漏洞逐项测试结果

### 漏洞一: com_fields 存储型XSS（低权限→RCE）

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Editor (组4, core.edit.value) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 站点页面未发现任何 `field-value` / `field-label` / `com_fields` 相关HTML输出
- 首页featured articles列表为空（无可编辑的公开文章）
- 用户注册已关闭，无法获取Editor/Manager账号进行存储型XSS测试
- **结论**: 代码层面漏洞存在（Joomla 4.3.4代码包含该漏洞），但该资产上无法获取Editor及以上权限，实际利用链无法完成

---

### 漏洞二: API用户创建/编辑越权提权

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | 持有 `core.login.api` 的API用户 |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/users` 返回401 Forbidden (需认证)
- 无公开API用户注册入口
- 用户注册已关闭
- 无默认API凭据可用
- **结论**: API端点存在且理论上存在越权，但无法获取API访问凭据

---

### 漏洞三: com_templates deleteFile 目录遍历任意文件删除

| 项目 | 内容 |
|------|------|
| **受影响版本** | 3.x - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Admin (Super Admin级) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 需要管理员登录 `/administrator/` 并访问 `com_templates` 组件
- 无管理员凭据可用
- 用户注册已关闭
- **结论**: 代码漏洞存在，但无管理员权限无法利用

---

### 漏洞四: com_banners custombannercode 存储型XSS（低权限→RCE）

| 项目 | 内容 |
|------|------|
| **受影响版本** | 3.x - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Editor (组4, core.edit) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 站点页面未发现 `mod_banners` 模块或 `com_banners` 组件输出
- 首页和所有测试页面均无banner显示
- 用户注册已关闭，无法获取Editor账号
- `index.php?option=com_banners&view=banners` 返回404
- **结论**: 即使有Editor账号，该站点也未激活banners模块/组件

---

### 漏洞五: com_finder 反射型XSS

| 项目 | 内容 |
|------|------|
| **受影响版本** | 2.5 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | 无 (访客可访问) |
| **可利用性** | ⚠️ **理论存在, 实际利用受限** |

**测试详情:**
- com_finder智能搜索组件对外开放，无需认证即可访问
- 搜索页面 `search-query-explained` 区块可见，搜索词以 `<span class="query-required"><span class="term">` 标签回显
- 搜索词同时在以下位置回显:
  - meta description标签（如 `test è obbligatorio`）
  - breadcrumb导航（`<span>test</span>`）
  - 搜索结果标题/描述
  - RSS feed（CDATA包裹，安全）
- **分词器过滤测试结果:**
  - `<`, `>`, `"`, `'`, `&`, `%`, `/`, `\\`, `@`, `!`, `#`, `$`, `^`, `(`, `)`, `=`, `|`, `:`, `;`, `,`, `?`, `~`, `` ` `` → 被strip
  - `[`, `]`, `{`, `}` → 导致查询为空
  - `-` → 保留（如 `a-b`）
  - `'` → 部分保留（如 `'a'b'`）
  - Unicode全角字符`＜＞` → 被strip
- **结论**: 代码层面（`Query.php:45` 使用 `Text::sprintf()` 不转义输出）存在漏洞，但默认分词器配置下HTML标签字符在存储到搜索索引前即被剥离，无法直接注入 `<>` 等XSS关键字符。属于防御纵深漏洞，需修改分词器配置或自定义查询才可绕过。**该资产上com_finder分词器已有效防御此XSS**。

---

### 漏洞六: PageBreak 折叠面板存储型XSS

| 项目 | 内容 |
|------|------|
| **受影响版本** | 3.x - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Editor (可编辑文章) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 站点无可见文章内容
- `index.php?option=com_content&view=article&id=1` 返回404
- `featured` 视图返回空白博客页面
- 用户注册已关闭，无法获取Editor账号
- 未发现 `system-pagebreak` / accordion 分页内容
- **结论**: 无可用Editor账号且站点无内容，无法利用

---

### 漏洞七: com_joomlaupdate Zip Slip 任意文件写入

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.4 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Super Admin |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 需要Super Admin权限访问com_joomlaupdate组件
- 无法获取管理员凭据
- 用户注册已关闭
- **结论**: 无Super Admin权限无法利用

---

### 漏洞八: com_templates copyFile 任意文件读取（目录遍历）

| 项目 | 内容 |
|------|------|
| **受影响版本** | 3.x - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | Admin (模板编辑权限) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- 需要管理员登录访问 `com_templates` 组件
- 无法获取管理员凭据
- **结论**: 无管理员权限无法利用

---

### 漏洞九: API LevelsController 访问等级越权

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | API用户 (core.login.api) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/languages` 返回401
- 无API凭据
- **结论**: 端点存在但需认证

---

### 漏洞十: API Menus ItemsController 菜单项越权

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | API用户 |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/menus` 返回404 (未注册)
- **结论**: 该API端点未在该站点启用

---

### 漏洞十一: API FieldsController 自定义字段跨组件越权

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | API用户 |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/fields` 返回404 (未注册)
- **结论**: 该API端点未在该站点启用

---

### 漏洞十二: com_categories API 分类跨组件越权

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | API用户 |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/categories` 返回404 (未注册)
- **结论**: 该API端点未在该站点启用

---

### 漏洞十三: com_privacy API 导出IDOR信息泄露

| 项目 | 内容 |
|------|------|
| **受影响版本** | 4.0.0 - 6.2.0-alpha1 |
| **当前版本** | 4.3.4 ✅ 在范围内 |
| **最低权限** | API用户 (core.login.api) |
| **可利用性** | ❌ **不可利用** |

**测试详情:**
- `/api/index.php/v1/privacy/requests` 返回401 (需认证)
- 无API凭据
- **结论**: 端点存在但需认证

---

## 总结

| 漏洞 | 名称 | 可利用性 | 原因 |
|------|------|---------|------|
| 漏洞一 | com_fields 存储型XSS | ❌ | 需Editor权限, 注册关闭 |
| 漏洞二 | API用户越权提权 | ❌ | 需API凭据, 无获取途径 |
| 漏洞三 | com_templates deleteFile目录遍历 | ❌ | 需管理员权限 |
| 漏洞四 | com_banners 存储型XSS | ❌ | 需Editor权限, 注册关闭; Banner未激活 |
| 漏洞五 | com_finder 反射型XSS | ⚠️ 理论存在 | 代码未转义, 但分词器剥离特殊字符 |
| 漏洞六 | PageBreak 存储型XSS | ❌ | 需Editor权限, 注册关闭 |
| 漏洞七 | com_joomlaupdate Zip Slip | ❌ | 需Super Admin权限 |
| 漏洞八 | com_templates copyFile目录遍历 | ❌ | 需管理员权限 |
| 漏洞九 | API LevelsController越权 | ❌ | 需API凭据 |
| 漏洞十 | API Menus ItemController越权 | ❌ | 端点未注册(404) |
| 漏洞十一 | API FieldsController越权 | ❌ | 端点未注册(404) |
| 漏洞十二 | com_categories API越权 | ❌ | 端点未注册(404) |
| 漏洞十三 | com_privacy API IDOR | ❌ | 需API凭据 |

**整体结论:**
- **somministrazione.uiltemp.it (Joomla 4.3.4)** 是所有13个漏洞的受影响版本，但由于以下限制，**实际可利用的漏洞为零**:
  1. **用户注册关闭**: 无法获取Editor/Manager等低权限账号，导致需要认证的存储型XSS类漏洞（漏洞一/四/六）无法测试利用
  2. **API需要认证**: 所有API端点（v1/users, v1/languages, v1/privacy/requests）要求认证，且无获取API凭据的途径，导致API越权类漏洞（漏洞二/九/十三）无法利用；部分API端点（v1/content, v1/menus, v1/fields, v1/categories）甚至未注册（404）
  3. **com_finder分词器防御**: 漏洞五的代码层漏洞确实存在（`Text::sprintf()` 不转义输出），但默认分词器在建立索引时将HTML/JS特殊字符剥离，有效阻止了通过默认搜索接口的XSS利用
  4. **管理员接口需认证**: 漏洞三/七/八需要Admin/Super Admin权限，无法获取
  5. **站点内容简陋**: 首页仅显示空白featured blog、finder搜索框和登录模块，无公开文章内容、无banner激活、无自定义字段展示

- **该资产可作为"受影响版本范围内但实际无法利用"的典型案例参考**
