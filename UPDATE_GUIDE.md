# py-workspace 更新指南

## 为什么需要更新？

py-workspace 会持续改进和新增功能，例如：
- 🚀 v1.1：新增工作区自我进化功能
- 🔧 后续版本：性能优化、新命令、新模板

**建议定期更新以获得最新功能和修复。**

---

## 🔄 如何更新

### 方法 1：Git Pull（推荐）

**适用于**：通过 `git clone` 安装的用户

```bash
# 1. 进入 skill 目录
cd ~/.claude/skills/py-workspace

# 2. 拉取最新版本
git pull

# 3. 查看更新内容
git log -3 --oneline
```

**完成！** 下次调用 `/py-workspace` 时会使用最新版本。

---

### 方法 2：删除重装

**适用于**：不确定安装方式，或想彻底重装

```bash
# 1. 备份你的工作区（如果需要）
# 注意：这里备份的是 skill 本身，不是你的项目工作区

# 2. 删除旧版本
rm -rf ~/.claude/skills/py-workspace

# 3. 重新安装
cd ~/.claude/skills
git clone https://github.com/pinyin/py-workspace-skill.git py-workspace
```

---

## ⚠️ 更新后会影响我的工作区吗？

**不会！** 

更新 skill 不会改变你已经创建的工作区：

| 更新的内容 | 不会更新的内容 |
|----------|-------------|
| ✅ `~/.claude/skills/py-workspace/` 中的 skill 代码 | ✅ 你的项目根目录 |
| ✅ `SKILL.md`、模板文件 | ✅ 你已经创建的 `SOURCE_OF_TRUTH.md` |
| ✅ 新功能、新命令 | ✅ 你已经创建的 `AGENTS.md` |
| | ✅ 你的工作记录 |
| | ✅ 你的业务资料 |

**原因**：

- skill 文件存放在 `~/.claude/skills/py-workspace/`（全局）
- 你的工作区文件存放在 `你的项目目录/`（各自独立）

---

## 🆕 更新后如何使用新功能？

### 方式 1：重新初始化（全新项目）

如果是新项目，直接使用新版本：

```bash
cd 新项目目录
/py-workspace init
```

会自动使用最新的模板和规则。

---

### 方式 2：手动合并（已有项目）

如果是已有工作区，想获得新功能：

#### 选项 A：只想体验新命令（推荐）

**不需要修改任何文件**，直接调用新命令即可。

例如 v1.1 新增的自我进化功能：
- 工作记录达到 30 条后自动触发
- 无需修改 `AGENTS.md` 或 `SOURCE_OF_TRUTH.md`

#### 选项 B：想获得新模板规则

比较新旧模板，手动合并你需要的部分：

```bash
# 1. 查看最新的 AGENTS.md 模板
cat ~/.claude/skills/py-workspace/templates/AGENTS.md

# 2. 对比你的项目中的 AGENTS.md
# （用你喜欢的编辑器打开）

# 3. 复制你需要的新规则
# 例如：复制"工作区自我进化"章节到你的 AGENTS.md
```

**推荐工具**：
- VS Code：打开两个文件并排对比
- Git diff：`git diff --no-index 你的AGENTS.md ~/.claude/skills/py-workspace/templates/AGENTS.md`

#### 选项 C：完全重置为新版（⚠️ 慎用）

**警告**：会覆盖你的自定义规则！

```bash
# 1. 备份当前规则
cp AGENTS.md AGENTS.md.backup
cp SOURCE_OF_TRUTH.md SOURCE_OF_TRUTH.md.backup

# 2. 复制新模板
cp ~/.claude/skills/py-workspace/templates/AGENTS.md ./
cp ~/.claude/skills/py-workspace/templates/SOURCE_OF_TRUTH.md ./

# 3. 手动恢复你的自定义部分（从备份文件）
```

---

## 📋 查看版本和更新日志

### 查看当前版本

```bash
cd ~/.claude/skills/py-workspace
git log -1 --oneline
```

### 查看完整更新日志

```bash
cd ~/.claude/skills/py-workspace
git log --oneline
```

或访问 GitHub：https://github.com/pinyin/py-workspace-skill/commits/main

---

## 🔔 如何知道有新版本？

### 方法 1：定期检查（手动）

```bash
cd ~/.claude/skills/py-workspace
git fetch
git status
```

如果显示 `Your branch is behind 'origin/main'`，说明有新版本。

---

### 方法 2：订阅 GitHub（推荐）

1. 访问 https://github.com/pinyin/py-workspace-skill
2. 点击右上角 `Watch` → `Custom` → `Releases`
3. 每次发布新版本会收到邮件通知

---

## 🐛 更新后遇到问题？

### 问题 1：调用 `/py-workspace` 没反应

**可能原因**：skill 目录名错误

```bash
# 检查安装位置
ls ~/.claude/skills/

# 应该看到 py-workspace 文件夹
# 如果看到的是 py-workspace-skill，需要重命名：
mv ~/.claude/skills/py-workspace-skill ~/.claude/skills/py-workspace
```

---

### 问题 2：新功能没生效

**可能原因**：Claude Code 缓存了旧版本

**解决方法**：重启 Claude Code 应用

---

### 问题 3：更新后原有工作区出错

**可能原因**：模板格式变化导致旧文件不兼容

**解决方法**：

1. 读取错误提示，定位问题文件
2. 对比新模板格式：`cat ~/.claude/skills/py-workspace/templates/AGENTS.md`
3. 手动调整你的文件

**如果实在无法解决**：
- 提交 Issue：https://github.com/pinyin/py-workspace-skill/issues
- 附上错误信息和你的 `AGENTS.md`、`SOURCE_OF_TRUTH.md` 内容

---

## 📌 最佳实践

1. **定期更新**：每月检查一次是否有新版本
2. **新项目用新版**：全新项目直接用最新模板
3. **旧项目按需合并**：已有项目只复制需要的新功能
4. **备份再实验**：修改规则文件前先备份
5. **订阅更新通知**：Watch GitHub 仓库的 Releases

---

## 🎯 版本历史

### v1.1（2026-09-23）
- 🚀 新增：工作区自我进化功能
  - 累计 30 条工作记录后主动分析
  - 发现重复工作模式并建议生成 skill
  - 先沟通后落盘，节省 token
- 📝 更新：AGENTS.md 模板新增自我进化规则
- 📝 更新：SOURCE_OF_TRUTH.md 模板新增元数据区

### v1.0（2026-09-22）
- ✅ 初始版本
- ✅ 工作区初始化
- ✅ 智能文件分类
- ✅ 自动索引生成
- ✅ 规则协商制定

---

## 💬 需要帮助？

- GitHub Issues：https://github.com/pinyin/py-workspace-skill/issues
- 讨论区：https://github.com/pinyin/py-workspace-skill/discussions
- Email：你的邮箱（如果有）
