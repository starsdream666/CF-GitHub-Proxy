# CF-Workers-GitHub-Proxy

<div align="center">

🚀 **全场景 GitHub 访问加速代理** · Cloudflare Workers / Snippets 双模部署

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Cloudflare%20Workers-orange)](https://workers.cloudflare.com/)
[![Snippets](https://img.shields.io/badge/supports-Cloudflare%20Snippets-blueviolet)](https://developers.cloudflare.com/rules/snippets/)

</div>

---

## 📖 简介

在 **GitHub Release · Archive · Raw · API · Gist · Git Clone** 等链接前加上你的代理域名，即可通过 Cloudflare 全球边缘网络加速访问，解决国内访问 GitHub 缓慢、超时、断连的问题。

**本分支新增特性：**
- 🌓 浅色 / 深色主题 Web 操作界面
- 📦 Git Clone 命令一键生成 + 复制
- 📤 Git Push 支持（需 Business 及以上计划）
- 🔗 复制命令自动附带 `pushInsteadOf` 配置，push 直连 GitHub
- 🖥️ Workers 和 Snippets 双部署方案

---

## 🚀 快速开始

### 使用公开实例（轻量使用）

在 GitHub 链接前直接加以下任一前缀：

| 实例域名 | 状态 |
|----------|------|
| `https://ghfile.geekertao.top/` | 演示 |
| `https://gh.geekertao.top/` | 演示 |
| `https://github.dpik.top/` | 演示 |
| `https://gh.felicity.ac.cn/` | 演示 |

```
原始链接:  https://github.com/user/repo/releases/download/v1.0/file.zip
加速链接:  https://ghfile.geekertao.top/https://github.com/user/repo/releases/download/v1.0/file.zip
```

> ⚠️ 以上为演示用途，大量使用请自行部署。

### 使用 Web 界面

直接访问你的代理域名，在网页中粘贴链接或生成 clone 命令。

---

## 🌐 Web 界面

访问代理域名首页即可使用，功能包括：

| 功能区 | 说明 |
|--------|------|
| 🚀 文件/API 加速 | 粘贴 GitHub 链接，点击加速直接下载 |
| 📦 Git Clone 生成器 | 输入 `user/repo`（支持完整 URL），自动生成 clone 命令 |
| 📋 复制命令 | 一键复制 **clone 命令 + push 直连配置**，粘贴到终端即用 |
| 🌓 主题切换 | 浅色/深色一键切换，自动记忆偏好 |
| 📃 示例填充 | 6 种 URL 格式，点击自动填入输入框 |
| ⌨️ 快捷键 | `Ctrl+K` 聚焦文件输入 · `Ctrl+J` 聚焦 clone 输入 |

界面内嵌于 Worker 中（[index.html](./index.html)），无需额外托管静态资源。

---

## 📋 支持的 URL 类型

| 类型 | 示例 URL |
|------|----------|
| 📁 分支源码 | `https://github.com/user/repo/archive/master.zip` |
| 📦 Release 源码 | `https://github.com/user/repo/archive/v0.1.0.tar.gz` |
| 📥 Release 文件 | `https://github.com/user/repo/releases/download/v0.1.0/file.zip` |
| 📄 分支文件 | `https://github.com/user/repo/blob/main/README.md` |
| 💾 Commit 文件 | `https://github.com/user/repo/blob/abc123/filename` |
| 📝 Gist | `https://gist.githubusercontent.com/user/abc123/raw/file.py` |
| ☁️ API | `https://api.github.com/repos/user/repo` |
| 📦 Git Clone | `https://github.com/user/repo.git` (smart HTTP) |

---

## 🐙 Git Clone 与 Push

### Clone（通过代理加速）

```bash
git clone https://你的域名/https://github.com/用户/仓库.git
```

**私有仓库：**

```bash
git clone https://用户名:TOKEN@你的域名/https://github.com/用户/仓库.git
```

### Push 直连配置

Clone 后 git 会把代理地址存为 remote URL，导致 push 失败。执行以下命令让 push 自动直连 GitHub：

```bash
cd 仓库名
git config url."https://github.com/".pushInsteadOf "https://你的域名/https://github.com/"
```

或使用项目自带的一键脚本（仅需执行一次，全局生效）：

```bash
# Linux / macOS / Git Bash
./setup.sh 你的域名

# Windows PowerShell
.\setup.ps1 你的域名
```

> 💡 **最便捷方式**：使用 Web 界面的复制按钮，粘贴到终端的内容已同时包含 clone 命令和 push 配置，一条龙完成。

### 效果

```
git pull  → 走代理加速 ✅
git push  → 自动直连 GitHub ✅（pushInsteadOf 替你替换 URL）
```

---

## 🏗️ 部署

### 方式一：Cloudflare Workers（适合入门）

1. 打开 [Cloudflare Workers 控制台](https://dash.cloudflare.com/workers)
2. 创建新 Worker
3. 将 [`workers.js`](./workers.js) 内容粘贴到编辑器
4. 绑定自定义域名（需经过 Cloudflare 代理）
5. 保存并部署

> Workers Free 计划有 10ms CPU 限制，仅适合文件下载加速。如需 Git Push 支持，请使用 Snippets + Business 计划。

### 方式二：Cloudflare Snippets（推荐 · 需 Pro+ 计划）

1. 确认已开通 Snippets 功能（Pro 以上计划或灰度用户）
2. 在 Snippets 平台创建新 Snippet
3. 将 [`snippets.js`](./snippets.js) 内容粘贴到编辑器
4. 添加片段规则 → 自定义筛选表达式：

   ```
   (http.host eq "你的域名")
   ```

5. 保存并部署

> 将 `你的域名` 替换为实际代理域名，该域名必须经过 Cloudflare 代理（橙色云朵）。

### 两种部署方式对比

| | Workers | Snippets |
|---|---|---|
| 最低计划 | Free | Pro / Business |
| 请求体大小限制 | Free: ~100KB / Paid: 100MB | 继承域名计划 |
| Git Push 支持 | Paid 计划可用 | ✅ 推荐 |
| Web 界面 | ✅ | ✅ |
| 文件加速 | ✅ | ✅ |
| 部署复杂度 | 低 | 中 |

---

## 📁 项目文件

| 文件 | 说明 |
|------|------|
| [`workers.js`](./workers.js) | Cloudflare Worker 入口（Service Worker 格式） |
| [`snippets.js`](./snippets.js) | Cloudflare Snippet 入口（ES Module 格式） |
| [`index.html`](./index.html) | Web 操作界面（已内嵌于 Worker，也支持单独托管） |
| [`setup.sh`](./setup.sh) | Linux/macOS 一键配置脚本（`pushInsteadOf`） |
| [`setup.ps1`](./setup.ps1) | Windows PowerShell 一键配置脚本 |
| [`README.md`](./README.md) | 本文件 |

---

## ⚙️ 自定义配置

编辑 `workers.js` 或 `snippets.js` 顶部的常量：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `PREFIX` | `'/'` | 路由前缀，如 `example.com/gh/*` 则设为 `'/gh/'` |
| `jsdelivr` | `0` | 设为 `1` 开启 jsDelivr CDN 镜像（blob/raw 文件） |
| `whiteList` | `[]` | 路径白名单，填入后仅匹配的路径可访问，如 `['/username/']` |
| `ASSET_URL` | GitHub Pages 地址 | 静态资源回退地址（Worker 已内嵌首页，一般无需修改） |

---

## 🔧 工作原理

```
用户请求
  │
  ▼
https://你的域名/https://github.com/user/repo/archive/main.zip
  │
  ▼
Cloudflare Worker / Snippet
  │  1. 剥离代理域名，提取目标 URL
  │  2. 正则匹配 URL 类型
  │  3. 转发到 GitHub（保留 method/headers/body）
  │  4. 改写重定向 Location 保持经过代理
  │  5. 返回响应给客户端
  ▼
GitHub 服务器
```

- **GET 请求**（下载/浏览）：`redirect: 'manual'` 手动改写 Location，确保客户端始终走代理
- **POST 请求**（Git Push）：`redirect: 'follow'` 由运行时透明处理，避免 body 流消费问题
- **首页访问**：直接返回内嵌的 `index.html`，无需外部托管

---

## 🙏 致谢

本项目基于以下优秀开源项目：

- [gh-proxy](https://github.com/hunshcn/gh-proxy) — 核心代理逻辑
- [CF-Workers-GitHub](https://github.com/cmliu/CF-Workers-GitHub/) — 页面参考
- [jsproxy](https://github.com/EtherDream/jsproxy/) — 早期思路启发

---

## 💰 赞助

<a href="https://afdian.com/a/Geekertao" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/💵_爱发电-FF4D4D?style=flat-square&logo=usd&logoColor=white" alt="爱发电">
</a>
