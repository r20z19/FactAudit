# www.uiltemp.it — Joomla CMS 漏洞测试报告

## 基本信息

| 项目 | 内容 |
|------|------|
| **主机名** | www.uiltemp.it (https://www.uiltemp.it/) |
| **别名/关联** | uiltemp.it (同一服务器/同一 Joomla 实例) |
| **Joomla 版本** | 5.4.6 |
| **Web 服务器** | LiteSpeed |
| **WAF/防护** | openresty WAF（拦截默认 curl UA，正常浏览器 UA 可访问），Imunify360 bot-protection |
| **受影响版本范围** | 4.0.0 – 6.2.0-alpha1 |
| **www.uiltemp.it 是否在范围内** | ✅ 是 (5.4.6) |

## 结论

**www.uiltemp.it 与 uiltemp.it 运行在同一服务器/同一 Joomla 5.4.6 实例上。** 两个主机名解析至同一站点，共享相同的文件系统、数据库、模板 (YOOtheme Pro v5.0.35) 及插件配置。所有漏洞测试结果与 uiltemp.it 完全一致。

完整漏洞测试矩阵、API 端点探测结果、复现步骤等详细信息，请参见同目录下的 `uiltemp.it.md` 报告（11.8KB）。

## 关键发现摘要 (同 uiltemp.it)

| 漏洞编号 | 漏洞名称 | 理论上适用 | 实际可利用 | 说明 |
|---------|---------|:---------:|:----------:|------|
| 一 | com_fields XSS → RCE | ✅ | ❌ | 需 Editor/Manager 权限；注册已关闭 |
| 二 | API 用户越权提权 | ✅ | ❌ | 需 API Token 认证；API 端点 (v1/users) 被 Imunify360 拦截返回 403 |
| 三 | com_templates deleteFile XSS → RCE | ✅ | ❌ | 需 Admin/SuperAdmin 权限 |
| 四 | com_banners XSS → RCE | ✅ | ❌ | 需 Editor/Manager 权限；前端 com_banners 404 |
| 五 | com_finder 反射型 XSS | ✅ | ⚠️ 部分 | 代码层确认 query-explained 区块存在未转义输出 (Text::sprintf())；但 YOOtheme 模板覆盖隐藏 query-explained 区块，且默认 findermin 分词器剥离 HTML 特殊字符 (< > " ' = ( ) { } &)，实际利用严重受限 |
| 六 | PageBreak XSS | ✅ | ❌ | 需 Editor 权限创建含分页文章 |
| 七 | com_templates fileUpload XSS → RCE | ✅ | ❌ | 需 Admin/SuperAdmin 权限 |
| 八 | com_templates copyFile XSS → RCE | ✅ | ❌ | 需 Admin/SuperAdmin 权限 |
| 九 | API /v1/config 配置泄漏 | ✅ | ❌ | API 端点需认证；v1/config 返回 404 |
| 十 | API /v1/content 内容越权 | ✅ | ❌ | API 端点需认证；v1/content 返回 404 |
| 十一 | API /v1/menus 菜单越权 | ✅ | ❌ | API 端点需认证；v1/menus 返回 404 |
| 十二 | API /v1/users/list 用户枚举 | ✅ | ❌ | API 端点需认证；v1/users 返回 401/403 |
| 十三 | API /v1/privacy/export 数据泄漏 | ✅ | ❌ | API 端点需认证；v1/privacy/export 返回 401 |

## 最终判定

**www.uiltemp.it (Joomla 5.4.6)** — 13 个漏洞理论上全部适用 (版本 5.4.6 在 4.0.0–6.2.0-alpha1 范围内)，但在当前无认证凭证（注册关闭、API Token 不可获取、无管理员权限）的条件下，**无一漏洞可被可靠利用以获取实际危害**。漏洞五 (com_finder XSS) 在代码层面部分确认但实际利用受模板覆盖和分词器双重限制。

---
*本报告为 www.uiltemp.it 独立报告，测试结果与 uiltemp.it.md 完全一致。详细信息请参见 uiltemp.it.md。*
