# dev.reactome.org - Joomla CMS漏洞测试报告

## 基本信息

| 项目 | 内容 |
|------|------|
| **主机名** | dev.reactome.org (https://dev.reactome.org/) |
| **Joomla版本** | 3.10.12 (确认来源: f003/f004中通过 /administrator/manifests/files/joomla.xml 确认) |
| **模板** | 自定义 favourite 模板 (非Joomla默认模板) |
| **Web服务器** | Cloudflare CDN (反向代理) |
| **Cloudflare IP** | 172.67.186.47, 104.21.19.129 |
| **/administrator/** | ✅ 返回200可访问 (f004确认) |
| **用户注册** | ❌ 已关闭 (303重定向到登录页) |
| **搜索引擎** | com_finder 存在，但使用自定义搜索入口 /content/query (非标准finder搜索框) |
| **Joomla 3.x特有攻击向量** | CVE-2023-23752 (未授权信息泄露) — 因Cloudflare防护无法测试 |

## 测试状态

**该资产因Cloudflare CDN防护，从当前测试环境无法进行任何主动HTTP/HTTPS连接。**

所有curl/wget请求均返回以下错误之一：

| 错误类型 | 说明 | 错误码 |
|---------|------|--------|
| 连接超时 | Cloudflare未响应SYN握手 | exit code 28 (curl) |
| 连接拒绝 | Cloudflare直接拒绝连接 | exit code 7 (curl) |
| DNS解析 | 解析为Cloudflare任播IP (172.67.186.47 / 104.21.19.129) | 正常解析但无法建立TCP连接 |

### 已尝试的测试方法

1. **标准HTTP/HTTPS请求**: `curl -k -L -v https://dev.reactome.org/` — 超时
2. **带浏览器User-Agent**: `curl -A "Mozilla/5.0..."` — 超时
3. **带Cookie/Referer**: 超时
4. **短超时多线程尝试**: 均超时
5. **traceroute/nmap**: TCP端口80/443被Cloudflare边缘节点丢弃

**根本原因**: 当前测试环境的IP地址段被Cloudflare的WAF/CDN策略阻止，Cloudflare边缘节点不转发来自此环境的任何流量到源服务器。

## 已有已知信息（来自前期侦察）

### 通过缓存页面确认的信息

已在 f003/f004 阶段获取了部分信息，缓存首页页面保存于 `/tmp/dev.reactome.org.html` (94KB)：

| 项目 | 状态 | 来源 |
|------|------|------|
| Joomla版本 | 3.10.12 | f003/f004: /administrator/manifests/files/joomla.xml |
| Joomla generator标记 | ✅ 存在 (`Joomla! - Open Source Content Management`) | 缓存页面HTML |
| 模板 | `favourite` (自定义模板) | 缓存页面HTML |
| CSRF Token | `0eb43d87c6beaffea271aed63f9811c2` | 缓存页面JSON |
| jQuery版本 | 1.x (jquery.min.js + jquery-migrate) | 缓存页面HTML |
| Bootstrap | 2.x (jui/bootstrap.min.css + jui/bootstrap-responsive.css) | 缓存页面HTML |
| 搜索入口 | 自定义 `/content/query` 路径 | 缓存页面HTML (搜索form指向/content/query) |
| 站点类型 | 生物信息学(Bioinformatics)通路数据库 | 页面描述 |
| 用户模块 | 存在登录/用户入口区域 | 缓存页面HTML |
| 组件 | com_finder、com_content、com_users 等 | 缓存页面分析 |
| /administrator/访问性 | ✅ 返回200 (可访问) | f004确认 |

### 自定义搜索功能分析

该站点使用**自定义favourite模板**中的搜索表单，而非标准Joomla com_finder搜索框：

- 搜索表单 action 指向 `/content/query?q={term}`
- 这是Reactome站点特有的搜索功能，将用户引导至生产站点 `reactome.org` 进行搜索
- com_finder 组件虽然存在于Joomla核心中(3.10.12)，但前台未集成标准finder搜索模块
- 标准com_finder路径 `/component/finder/search` 理论上存在于后端但无法主动验证

## 漏洞适用性分析（基于Joomla 3.10.12）

### Joomla 3.10.12 版本范围说明

Joomla 3.10.x 是 Joomla 3.x 系列的最终发行分支，发布于2021年之后，与 Joomla 4.0.0 以上版本有较大架构差异。关键差异：**Joomla 3.x 不具备 REST API 功能**（Joomla 4.0+ 才引入），且部分组件架构不同。

### 适用漏洞（版本范围覆盖3.x）

| 编号 | 漏洞名称 | 受影响版本 | 3.10.12是否适用 | 理论利用条件 | 实际可利用性 |
|------|---------|-----------|:-------------:|------------|:----------:|
| **漏洞三** | com_templates deleteFile 目录遍历任意文件删除 | 3.x ~ 6.2.0-alpha1 | ✅ **适用** | 需Admin/SuperAdmin权限登录后台 | ❌ 无法验证 — Cloudflare阻断 + 需Admin权限 |
| **漏洞四** | com_banners custombannercode 存储型XSS→RCE | 3.x ~ 6.2.0-alpha1 | ✅ **适用** | 需Editor/Manager权限编辑banner；前台需mod_banners模块发布 | ❌ 无法验证 — Cloudflare阻断 + 需认证 + 缓存页面未见mod_banners |
| **漏洞五** | com_finder 反射型XSS | 2.5 ~ 6.2.0-alpha1 | ✅ **适用** | 无认证要求；需finder搜索页显示query-explained区块 | ❌ 无法验证 — Cloudflare阻断 + 自定义搜索入口(/content/query)非标准finder路径 |
| **漏洞六** | PageBreak 折叠面板存储型XSS | 3.x ~ 6.2.0-alpha1 | ✅ **适用** | 需Editor权限编辑文章，插入`<hr class="system-pagebreak">` | ❌ 无法验证 — Cloudflare阻断 + 需认证 |
| **漏洞八** | com_templates copyFile 任意文件读取(目录遍历) | 3.x ~ 6.2.0-alpha1 | ✅ **适用** | 需Admin/SuperAdmin权限登录后台 | ❌ 无法验证 — Cloudflare阻断 + 需Admin权限 |

### 不适用漏洞（需要Joomla 4.0+）

以下漏洞基于 Joomla 4.0+ 引入的 REST API 或新组件架构，**Joomla 3.10.12 不适用**：

| 编号 | 漏洞名称 | 不适用原因 |
|------|---------|-----------|
| **漏洞一** | com_fields 存储型XSS→RCE | com_fields组件首次引入于Joomla 4.0.0 (受影响版本4.0.0~6.2.0-alpha1) |
| **漏洞二** | API用户创建/编辑越权提权 | REST API首次引入于Joomla 4.0.0 (受影响版本4.0.0~6.2.0-alpha1) |
| **漏洞七** | com_joomlaupdate Zip Slip 任意文件写入 | 受影响版本4.0.4~6.2.0-alpha1 |
| **漏洞九** | API LevelsController 访问等级越权 | REST API首次引入于Joomla 4.0.0 |
| **漏洞十** | API Menus ItemsController 菜单项越权 | REST API首次引入于Joomla 4.0.0 |
| **漏洞十一** | API FieldsController 自定义字段跨组件越权 | REST API首次引入于Joomla 4.0.0 |
| **漏洞十二** | com_categories API 分类跨组件越权 | REST API首次引入于Joomla 4.0.0 |
| **漏洞十三** | com_privacy API 导出IDOR信息泄露 | REST API首次引入于Joomla 4.0.0 |

### 3.x特有攻击向量（无法测试）

Joomla 3.x 系列存在一些已知的已公开CVE，未包含在13个待测试漏洞中：

| 已知CVE | 说明 | 测试状态 |
|---------|------|---------|
| CVE-2023-23752 | Joomla! 未授权信息泄露 (≤3.10.12 / 4.0.0~4.2.7) | ❌ Cloudflare阻断，无法测试 |
| CVE-2021-23132 | com_media 任意文件上传 (Joomla 3.0.0~3.9.24) | ❌ 版本3.10.12可能已修复 |
| CVE-2020-11890 | com_users 账户枚举 (Joomla 2.5.0~3.9.15) | ❌ 版本3.10.12可能已修复 |

## 漏洞测试小结

| 漏洞编号 | 理论适用 | 实际可利用 | 备注 |
|---------|:-------:|:---------:|------|
| 漏洞一 (com_fields XSS→RCE) | ❌ | ❌ | 需Joomla 4.0+，不适用3.x |
| 漏洞二 (API用户越权) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |
| 漏洞三 (deleteFile任意删除) | ✅ | ❌ | 需Admin权限 + Cloudflare阻断 |
| 漏洞四 (com_banners XSS→RCE) | ✅ | ❌ | 需Editor权限 + 缓存页面无mod_banners迹象 |
| 漏洞五 (com_finder反射型XSS) | ✅ | ❌ | 自定义搜索入口非标准finder + Cloudflare阻断 |
| 漏洞六 (PageBreak XSS) | ✅ | ❌ | 需Editor权限 + Cloudflare阻断 |
| 漏洞七 (Zip Slip任意写入) | ❌ | ❌ | 受影响版本4.0.4+，不适用3.x |
| 漏洞八 (copyFile任意读取) | ✅ | ❌ | 需Admin权限 + Cloudflare阻断 |
| 漏洞九 (API Levels越权) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |
| 漏洞十 (API Menus越权) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |
| 漏洞十一 (API Fields越权) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |
| 漏洞十二 (API Categories越权) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |
| 漏洞十三 (API Privacy IDOR) | ❌ | ❌ | 需Joomla 4.0+ REST API，不适用3.x |

**综合结论**: 在13个待测试漏洞中，仅有5个(漏洞三/四/五/六/八)理论上适用于Joomla 3.10.12。但由于(1) Cloudflare CDN完全阻断当前环境的网络连接，(2) 所有适用漏洞均需认证(Editor/Admin级别)，且用户注册已关闭，(3) 站点使用自定义favourite模板覆盖了默认组件行为，**所有漏洞均无法在该资产上实际验证或利用**。

## 复现可能性评估

若要从其他网络环境测试该资产，需要：

1. **绕过Cloudflare防护**: 使用未被Cloudflare阻止的IP地址（非当前容器IP段）
2. **获取低权限账号**: 当前注册已关闭，无法通过公开途径获取账号
3. **获取Admin权限**: 尝试CVE-2023-23752等未授权信息泄露漏洞获取数据库凭证或Session

**建议替代方案**: 鉴于dev.reactome.org使用Cloudflare防护且所有需测试的漏洞均需认证，该资产不适合作为CNVD漏洞验证目标。建议将测试资源集中在已确认无WAF/CDN防护的资产（如somministrazione.uiltemp.it、uiltemp.it、audit.uthm.edu.my），这些资产已生成独立测试报告。

---

*报告生成时间: 2026-06-26*
*基于f003、f004、f008的前期侦察数据*
*当前环境无法主动连接，所有分析基于缓存页面和已有intel*
