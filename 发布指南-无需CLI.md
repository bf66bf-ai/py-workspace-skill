# py-workspace Skill 发布指南（无需 GitHub CLI）

## 步骤 1：创建 GitHub 仓库（等待速率限制解除后）

**等待 10 分钟后**，打开浏览器：

```
https://github.com/new
```

填写信息：
```
Repository name: py-workspace-skill

Description: 
Claude Code skill for workspace management - beginner-friendly, step-by-step guidance

选择: ● Public (公开)

不要勾选：
□ Add a README file
□ Add .gitignore  
□ Choose a license
```

点击 **Create repository**

---

## 步骤 2：运行发布脚本

在命令行运行：

```bash
cd "/e/桌面/拼音的Codex工作区/tmp/workspace-manager-skill"
bash 发布脚本.sh
```

脚本会自动：
1. 添加远程仓库
2. 推送代码到 GitHub
3. 告诉你下一步做什么

**如果弹出登录窗口**：
- 输入 GitHub 用户名和密码
- 或者使用 Personal Access Token

---

## 步骤 3：创建 Release

脚本推送成功后，打开：

```
https://github.com/pinyin/py-workspace-skill/releases/new
```

填写：
```
Tag version: v1.0.0
  (输入后点击 "Create new tag: v1.0.0 on publish")

Release title: py-workspace v1.0.0 - 新手友好的工作区管理系统

描述框：
  复制 .github-release-template.md 的全部内容
```

勾选：
☑ Set as the latest release

点击 **Publish release**

---

## 步骤 4：测试安装

```bash
cd ~/.claude/skills
git clone https://github.com/pinyin/py-workspace-skill.git py-workspace
```

测试功能：
```bash
cd ~/test-project
/py-workspace init
```

应该看到新手引导输出。

---

## 完成！

发布成功后，用户可以通过以下方式安装：

```bash
cd ~/.claude/skills
git clone https://github.com/pinyin/py-workspace-skill.git py-workspace
```

---

## 如果遇到问题

### 问题 1：推送时要求认证

Windows 会弹出 GitHub 登录窗口：
- 用户名: pinyin
- 密码: 你的 GitHub 密码或 Personal Access Token

### 问题 2：生成 Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选 `repo` 权限
4. 复制生成的 token
5. 在密码框粘贴 token

### 问题 3：Git 说仓库不存在

确认：
1. 仓库已在 GitHub 创建
2. 仓库名是 `py-workspace-skill`
3. 等待 1-2 分钟后重试

---

## 联系我

如果有任何问题，随时告诉我，我会帮你解决！
