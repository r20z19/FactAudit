# Joomla Admin Credential Sweep Report

**Generated**: Fri Jun 26 16:37:38 CST 2026
**Scope**: Content-based credential sweep with HTML analysis
**Method**: POST to /administrator/index.php, follow redirect, analyze HTML for admin dashboard markers

## Detection Criteria

| Marker | Weight | Description |
|--------|--------|-------------|
| body class != com_login | +10 | Body class does not contain 'com_login' (gold standard) |
| no mod-login form | +8 | Login form HTML not present |
| nav-list/nav-stacked | +2-6 | Admin navigation menu detected |
| com_content/com_users/com_menus links | +4 each | Admin component links in page |
| logout links | +3 | Logout functionality present |
| sidebar class | +1-3 | Admin sidebar present |
| dashboard-wrapper | +2 | Dashboard container detected |
| session expired msg | -5 | Auth did not persist |

**Score interpretation**: >10 = likely admin dashboard, 5-10 = possible success, <5 = login page

---

## Target: 102.23.132.19 (5.0.0)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 18844 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 2 | admin | joomla | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 3 | admin | 123456 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 4 | admin | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 5 | admin | admin123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 6 | admin | administrator | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 7 | admin | root | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 8 | admin | toor | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 9 | admin | letmein | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 10 | admin | welcome | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 11 | admin | Passw0rd | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 12 | admin | joomla123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 13 | administrator | administrator | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 14 | administrator | admin | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 15 | administrator | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 16 | administrator | 123456 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 17 | administrator | admin123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 18 | root | root | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 19 | root | admin | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 20 | root | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 21 | root | 123456 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 22 | admin | Admin123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 23 | admin | Admin@123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 24 | admin | P@ssw0rd | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 25 | admin | changeme | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 26 | superadmin | superadmin | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 27 | superadmin | admin | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 28 | superadmin | password | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 29 | user | user | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 30 | user | password | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 31 | user | 123456 | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 32 | admin | admin2024 | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 33 | admin | Joomla2024 | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 34 | webmaster | webmaster | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 35 | webmaster | admin | 2003 | cl,ml | admin com_login view-login layout-default | 19093 | SUCCESS |
| 36 | webmaster | password | 2 | no-cl,ml |  | 0 | Failed |
| 37 | test | test | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 38 | test | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 39 | test | 123456 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 40 | demo | demo | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 41 | demo | admin | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 42 | demo | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 43 | editor | editor | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 44 | editor | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 45 | manager | manager | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 46 | manager | admin | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 47 | manager | password | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 48 | admin | superadmin | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 49 | admin | Passw0rd! | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |
| 50 | admin | joomla@123 | 2003 | cl,ml | admin com_login view-login layout-default | 18008 | SUCCESS |

**Best credential**: admin/admin (score: 2003)

---

## Target: 103.151.89.205 (4.2.4)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 15574 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 2 | admin | joomla | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 3 | admin | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 4 | admin | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 5 | admin | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 6 | admin | administrator | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 7 | admin | root | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 8 | admin | toor | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 9 | admin | letmein | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 10 | admin | welcome | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 11 | admin | Passw0rd | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 12 | admin | joomla123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 13 | administrator | administrator | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 14 | administrator | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 15 | administrator | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 16 | administrator | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 17 | administrator | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 18 | root | root | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 19 | root | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 20 | root | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 21 | root | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 22 | admin | Admin123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 23 | admin | Admin@123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 24 | admin | P@ssw0rd | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 25 | admin | changeme | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 26 | superadmin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 27 | superadmin | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 28 | superadmin | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 29 | user | user | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 30 | user | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 31 | user | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 32 | admin | admin2024 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 33 | admin | Joomla2024 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 34 | webmaster | webmaster | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 35 | webmaster | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 36 | webmaster | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 37 | test | test | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 38 | test | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 39 | test | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 40 | demo | demo | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 41 | demo | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 42 | demo | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 43 | editor | editor | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 44 | editor | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 45 | manager | manager | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 46 | manager | admin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 47 | manager | password | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 48 | admin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 49 | admin | Passw0rd! | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |
| 50 | admin | joomla@123 | 200 | cl,ml | admin com_login view-login layout-default | 15763 | Failed |

**Best credential**: None (score: 0)

---

## Target: 113.22.20.198 (4.0.4)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 16095 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 2 | admin | joomla | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 3 | admin | 123456 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 4 | admin | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 5 | admin | admin123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 6 | admin | administrator | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 7 | admin | root | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 8 | admin | toor | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 9 | admin | letmein | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 10 | admin | welcome | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 11 | admin | Passw0rd | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 12 | admin | joomla123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 13 | administrator | administrator | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 14 | administrator | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 15 | administrator | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 16 | administrator | 123456 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 17 | administrator | admin123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 18 | root | root | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 19 | root | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 20 | root | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 21 | root | 123456 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 22 | admin | Admin123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 23 | admin | Admin@123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 24 | admin | P@ssw0rd | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 25 | admin | changeme | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 26 | superadmin | superadmin | 3032 | no-cl,ml |  | 0 | SUCCESS |
| 27 | superadmin | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 28 | superadmin | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 29 | user | user | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 30 | user | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 31 | user | 123456 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 32 | admin | admin2024 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 33 | admin | Joomla2024 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 34 | webmaster | webmaster | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 35 | webmaster | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 36 | webmaster | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 37 | test | test | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 38 | test | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 39 | test | 123456 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 40 | demo | demo | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 41 | demo | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 42 | demo | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 43 | editor | editor | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 44 | editor | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 45 | manager | manager | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 46 | manager | admin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 47 | manager | password | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 48 | admin | superadmin | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 49 | admin | Passw0rd! | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |
| 50 | admin | joomla@123 | 2000 | cl,ml | admin com_login view-login layout-default | 16368 | SUCCESS |

**Best credential**: superadmin/superadmin (score: 3032)

---

## Target: 120.26.36.78 (6.0.2)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 14115 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 2 | admin | joomla | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 3 | admin | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 4 | admin | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 5 | admin | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 6 | admin | administrator | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 7 | admin | root | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 8 | admin | toor | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 9 | admin | letmein | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 10 | admin | welcome | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 11 | admin | Passw0rd | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 12 | admin | joomla123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 13 | administrator | administrator | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 14 | administrator | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 15 | administrator | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 16 | administrator | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 17 | administrator | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 18 | root | root | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 19 | root | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 20 | root | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 21 | root | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 22 | admin | Admin123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 23 | admin | Admin@123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 24 | admin | P@ssw0rd | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 25 | admin | changeme | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 26 | superadmin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 27 | superadmin | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 28 | superadmin | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 29 | user | user | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 30 | user | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 31 | user | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 32 | admin | admin2024 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 33 | admin | Joomla2024 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 34 | webmaster | webmaster | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 35 | webmaster | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 36 | webmaster | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 37 | test | test | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 38 | test | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 39 | test | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 40 | demo | demo | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 41 | demo | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 42 | demo | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 43 | editor | editor | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 44 | editor | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 45 | manager | manager | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 46 | manager | admin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 47 | manager | password | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 48 | admin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 49 | admin | Passw0rd! | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |
| 50 | admin | joomla@123 | 200 | cl,ml | admin com_login view-login layout-default | 14304 | Failed |

**Best credential**: None (score: 0)

---

## Target: 136.109.144.159 (5.4.6)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 10825 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 2 | admin | joomla | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 3 | admin | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 4 | admin | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 5 | admin | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 6 | admin | administrator | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 7 | admin | root | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 8 | admin | toor | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 9 | admin | letmein | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 10 | admin | welcome | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 11 | admin | Passw0rd | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 12 | admin | joomla123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 13 | administrator | administrator | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 14 | administrator | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 15 | administrator | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 16 | administrator | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 17 | administrator | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 18 | root | root | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 19 | root | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 20 | root | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 21 | root | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 22 | admin | Admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 23 | admin | Admin@123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 24 | admin | P@ssw0rd | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 25 | admin | changeme | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 26 | superadmin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 27 | superadmin | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 28 | superadmin | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 29 | user | user | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 30 | user | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 31 | user | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 32 | admin | admin2024 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 33 | admin | Joomla2024 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 34 | webmaster | webmaster | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 35 | webmaster | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 36 | webmaster | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 37 | test | test | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 38 | test | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 39 | test | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 40 | demo | demo | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 41 | demo | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 42 | demo | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 43 | editor | editor | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 44 | editor | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 45 | manager | manager | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 46 | manager | admin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 47 | manager | password | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 48 | admin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 49 | admin | Passw0rd! | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |
| 50 | admin | joomla@123 | 200 | cl,ml | admin com_login view-login layout-default | 11014 | Failed |

**Best credential**: None (score: 0)

---

## Target: 149.28.103.70 (6.0.0)

| # | Username | Password | Score | Markers | Body Class | Size | Verdict |
|---|----------|----------|-------|---------|------------|------|---------|
  *Baseline: HTTP 200, 11622 bytes, body class: admin com_login view-login layout-default*
| 1 | admin | admin | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 2 | admin | joomla | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 3 | admin | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 4 | admin | password | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 5 | admin | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 6 | admin | administrator | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 7 | admin | root | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 8 | admin | toor | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 9 | admin | letmein | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 10 | admin | welcome | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 11 | admin | Passw0rd | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 12 | admin | joomla123 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 13 | administrator | administrator | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 14 | administrator | admin | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 15 | administrator | password | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 16 | administrator | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 17 | administrator | admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 18 | root | root | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 19 | root | admin | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 20 | root | password | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 21 | root | 123456 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 22 | admin | Admin123 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 23 | admin | Admin@123 | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 24 | admin | P@ssw0rd | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 25 | admin | changeme | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 26 | superadmin | superadmin | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 27 | superadmin | admin | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 28 | superadmin | password | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
| 29 | user | user | 200 | cl,ml | admin com_login view-login layout-default | 11811 | Failed |
