# Workspace Manager Skill - 快速开始指南

## 5 分钟快速体验

### 1. 安装（30 秒）

```bash
# 克隆到 Claude Code skills 目录
cd ~/.claude/skills
git clone https://github.com/你的用户名/workspace-manager-skill.git workspace-manager

# 或者手动安装
# 1. 下载 ZIP
# 2. 解压到 ~/.claude/skills/workspace-manager/
```

### 2. 初始化（1 分钟）

在你的工作目录中：

```bash
/workspace-manager init
```

你会看到：
```
✅ 工作区初始化完成

创建了以下结构：
- SOURCE_OF_TRUTH.md
- AGENTS.md
- 工作记录/
- 文件上传区/
- 文件下载区/

接下来你可以：
1. 将业务资料放入「文件上传区/」
2. 调用 /workspace-manager organize 开始整理
```

### 3. 放入资料（2 分钟）

按你的习惯分类，或直接放入：

```
文件上传区/
├── 客户项目/
│   └── 客户A-需求.docx
├── 课程资料/
│   └── 课程大纲.pdf
└── 未命名文件.xlsx
```

### 4. 整理归档（1.5 分钟）

```bash
/workspace-manager organize
```

Agent 会：
1. 识别你的分类习惯
2. 对未分类文件给出建议
3. 与你确认后移动文件
4. 生成索引和规则

完成后你的工作区：

```
你的项目/
├── SOURCE_OF_TRUTH.md    # 自动生成的导航
├── AGENTS.md              # 自动生成的规则
├── 工作记录/
├── 文件上传区/            # 已清空
├── 文件下载区/
├── 客户项目/              # 从上传区移动来的
└── 课程资料/              # 从上传区移动来的
```

## 常见使用场景

### 新增资料

```bash
# 1. 放入文件上传区
# 2. 运行
/workspace-manager organize
```

### 准备交付

```
你：这个方案要发给客户了
Agent：已复制到「文件下载区/」，可以打包发送
```

### 查找资料

```
你：我的客户合同在哪？
Agent：[读取 SOURCE_OF_TRUTH.md]
      在「客户项目/」目录，共 3 个合同文件
```

## 下一步

- 阅读 [完整文档](README.md)
- 查看 [咨询顾问案例](examples/consultant-example.md)
- 了解 [开发细节](docs/DEVELOPMENT.md)

## 需要帮助？

- [提交 Issue](https://github.com/你的用户名/workspace-manager-skill/issues)
- [查看 FAQ](README.md#常见问题)
