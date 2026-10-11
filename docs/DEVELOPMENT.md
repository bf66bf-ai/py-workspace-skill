# Workspace Manager Skill - 开发文档

## 项目结构

```
py-workspace-skill/
├── SKILL.md                           # 主 skill 文件（Claude Code 读取）
├── README.md                          # 用户文档
├── LICENSE                            # MIT 许可证
├── .gitignore                         # Git 忽略规则
├── templates/                         # 模板文件
│   ├── SOURCE_OF_TRUTH.md            # 导航文件模板
│   └── AGENTS.md                     # 规则文件模板
├── examples/                          # 使用示例
│   └── consultant-example.md         # 咨询顾问案例
└── docs/                              # 开发文档
    └── DEVELOPMENT.md                # 本文件
```

## 核心设计理念

### 1. 对话式引导 > 固定模板

不预设用户的业务分类，而是通过识别用户习惯动态创建。

**错误做法**：
```
创建固定结构：
├── 客户/
├── 产品/
└── 营销/
```

**正确做法**：
```
用户放入：
文件上传区/客户项目/  → 创建：客户项目/
文件上传区/课程资料/  → 创建：课程资料/
```

### 2. 移动而非复制

文件从上传区处理后，直接 `mv` 到目标位置，不留副本。

**原因**：避免"这个文件的最新版在哪"的困扰。

**例外**：文件下载区是交付物备份，允许复制。

### 3. 协商确认 > 自动决策

内容识别给出建议，但最终由用户确认。

```python
# 伪代码
建议 = 识别文件内容()
用户确认 = 询问用户(建议)
if 用户确认.修改了分类:
    使用用户的分类
else:
    使用建议分类
```

### 4. 最小化启动 > 功能完备

初始只创建必需的三层结构，其他功能按需添加。

**不包含**：
- 个人商业诊断（独立 skill）
- 飞书同步（独立 skill）
- 商业验证闸门（独立 skill）

## 技术实现

### init 命令实现

```python
def workspace_init():
    # 1. 检查当前状态
    if exists("SOURCE_OF_TRUTH.md") or exists("AGENTS.md"):
        response = ask_user("工作区文件已存在，是否覆盖？")
        if not response:
            return
    
    # 2. 创建目录结构
    mkdir_p("工作记录")
    mkdir_p("文件上传区")
    mkdir_p("文件下载区")
    
    # 3. 复制模板文件
    copy("templates/SOURCE_OF_TRUTH.md", "SOURCE_OF_TRUTH.md")
    copy("templates/AGENTS.md", "AGENTS.md")
    
    # 4. 创建今日工作记录
    today = datetime.now().strftime("%Y-%m-%d")
    create_work_log(f"工作记录/{today}.md", "初始化工作区")
    
    # 5. 输出引导信息
    print_guidance()
```

### organize 命令实现

```python
def workspace_organize():
    upload_dir = "文件上传区/"
    
    # 1. 扫描上传区
    pre_classified = scan_folders(upload_dir)
    unclassified = scan_files(upload_dir)
    
    # 2. 处理预分类文件夹
    if pre_classified:
        print(f"发现预分类文件夹：{pre_classified}")
        if confirm_user():
            for folder in pre_classified:
                create_folder_in_root(folder.name)
                move_files(folder, root / folder.name)
    
    # 3. 处理未分类文件
    if unclassified:
        suggestions = []
        for file in unclassified:
            category = identify_content(file)
            suggestions.append({
                "file": file,
                "category": category,
                "reason": explain_reason(file, category)
            })
        
        print_suggestions(suggestions)
        confirmed = negotiate_with_user(suggestions)
        
        for item in confirmed:
            create_folder_in_root(item.category)
            move_file(item.file, root / item.category)
    
    # 4. 生成索引
    index = scan_all_folders(root)
    update_navigation(index)
    
    # 5. 记录日志
    log_to_today(f"整理完成：{len(files)}个文件")
    
    # 6. 协商规则
    negotiate_rules()
```

### 内容识别逻辑

```python
def identify_content(file):
    """
    识别文件内容类型
    返回建议的分类名称
    """
    # 1. 文件扩展名快速判断
    ext = file.suffix.lower()
    if ext in [".mp4", ".mov", ".avi"]:
        return "视频素材"
    
    # 2. 文件名关键词
    keywords = extract_keywords(file.name)
    if any(k in keywords for k in ["合同", "需求", "交付"]):
        return "客户项目"
    if any(k in keywords for k in ["课程", "大纲", "教学"]):
        return "课程资料"
    if any(k in keywords for k in ["文案", "脚本", "海报"]):
        return "营销素材"
    
    # 3. 文本文件读取内容
    if ext in [".md", ".txt", ".docx", ".pdf"]:
        content = read_first_n_chars(file, 500)
        keywords = extract_keywords(content)
        return classify_by_keywords(keywords)
    
    # 4. 无法识别
    return "待分类"

def explain_reason(file, category):
    """
    生成分类理由说明
    """
    if category == "客户项目":
        return "包含合同、报价、交付等关键词"
    elif category == "课程资料":
        return "包含章节结构和知识点"
    # ...
    else:
        return "根据文件名和内容综合判断"
```

### 工作记录机制

```python
def ensure_today_log():
    """
    确保今天的工作记录文件存在
    """
    today = datetime.now().strftime("%Y-%m-%d")
    log_path = f"工作记录/{today}.md"
    
    if not exists(log_path):
        create_file(log_path, f"# {today} 工作记录\n\n")
    
    return log_path

def log_to_today(content, time=None):
    """
    记录到今日工作日志
    """
    if time is None:
        time = datetime.now().strftime("%H:%M")
    
    log_path = ensure_today_log()
    append_to_file(log_path, f"\n## {time} {content}\n")
```

### 规则协商

```python
def negotiate_rules():
    """
    与用户协商制定使用规则
    """
    print("📋 资料已经就位，现在我们来确定几条使用规则：")
    
    # 1. 读取优先级
    folders = list_folders(exclude=["工作记录", "文件上传区", "文件下载区"])
    suggested_priority = suggest_priority(folders)
    
    print(f"\n1. **读取优先级**")
    print(f"   建议：{' > '.join(suggested_priority)}")
    
    confirmed_priority = ask_user_priority(suggested_priority)
    
    # 2. 版本冲突处理
    print(f"\n2. **版本冲突处理**")
    print(f"   建议：文件修改时间越新，优先级越高")
    
    # 用户通常接受默认建议
    
    # 3. 引用确认
    print(f"\n3. **引用确认**")
    for folder in folders:
        sensitivity = detect_sensitivity(folder)
        if sensitivity == "public":
            print(f"   {folder}/ - 可以直接引用")
        else:
            print(f"   {folder}/ - 需要先确认（涉及隐私）")
    
    # 4. 写入 AGENTS.md
    rules = generate_rules(confirmed_priority, folders)
    update_agents_md(rules)
    
    print("\n✅ 规则已保存到 AGENTS.md")
```

## Claude Code 集成

### YAML Frontmatter

```yaml
---
name: py-workspace
description: 为服务类创业者初始化科学工作区管理体系
when_to_use: 用户要求"初始化工作区"、"创建工作区"、"整理工作区文件"
---
```

**关键点**：
- `name` 是 slash 命令的名称
- `description` 在自动补全时显示
- `when_to_use` 帮助 Claude 判断何时调用

### Skill 激活

用户输入以下任一命令时，Claude 会读取 SKILL.md：

```bash
/py-workspace init
/py-workspace organize
/py-workspace  # 显示帮助
```

## 测试策略

### 单元测试场景

1. **空目录初始化**
   - 输入：空目录
   - 期望：创建完整的三层结构

2. **已有文件的目录**
   - 输入：包含 SOURCE_OF_TRUTH.md 的目录
   - 期望：询问是否覆盖

3. **预分类文件夹识别**
   - 输入：上传区有子文件夹
   - 期望：保留用户命名，在根目录创建同名文件夹

4. **内容识别准确性**
   - 输入：各种类型的文件
   - 期望：正确识别或给出合理建议

5. **文件移动操作**
   - 输入：上传区有文件
   - 期望：文件移动到目标，上传区清空

### 集成测试场景

1. **完整工作流**
   ```bash
   /py-workspace init
   # 用户放入文件
   /py-workspace organize
   # 检查结果
   ```

2. **跨窗口续接**
   ```bash
   # 窗口 1: 初始化并整理
   # 窗口 2: 新窗口，询问"昨天做了什么"
   # 期望：Agent 读取工作记录并回答
   ```

3. **交付物备份**
   ```bash
   # 创建文件
   # 告诉 Agent "这个要交付"
   # 期望：复制到文件下载区
   ```

### 用户测试清单

- [ ] 咨询顾问场景
- [ ] 培训师场景
- [ ] 设计师场景
- [ ] 内容创作者场景

## 发布流程

### 1. 本地测试

```bash
# 复制到 skills 目录
cp -r py-workspace-skill ~/.claude/skills/py-workspace

# 在测试项目中调用
cd ~/test-project
/py-workspace init
```

### 2. 创建 GitHub 仓库

```bash
cd py-workspace-skill
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/bf66bf-ai/py-workspace-skill.git
git push -u origin main
```

### 3. 编写安装文档

在 README.md 中提供清晰的安装步骤。

### 4. 发布 Release

```bash
git tag -a v1.0.0 -m "First stable release"
git push origin v1.0.0
```

### 5. 社区推广

- [ ] 在 Claude Code Discord 分享
- [ ] 在 Twitter/X 发布
- [ ] 写博客文章介绍使用案例

## 常见问题

### Q: SKILL.md 太长会影响性能吗？

A: 当前版本约 500 行，在 Claude Code 的推荐范围内（< 500 行）。如果未来功能增加，考虑拆分为：
- SKILL.md（核心流程）
- references/（详细文档）

### Q: 如何支持其他语言？

A: 当前版本是中文。要支持英文：
1. 创建 `SKILL.en.md`
2. 修改 frontmatter 添加 `language: zh-CN`
3. 让用户选择安装哪个版本

### Q: 可以自定义模板吗？

A: 可以。用户可以：
1. 编辑 `templates/` 下的文件
2. 或者在 init 后手动修改生成的文件

### Q: 与 Git 的关系？

A: 
- Skill 本身不操作 Git
- 建议用户将工作区文件纳入 Git 版本管理
- 工作记录/ 是很好的 commit 参考

## 路线图

### v1.1（计划中）

- [ ] 支持自定义模板
- [ ] 添加 `/py-workspace status` 查看当前状态
- [ ] 支持批量重命名文件

### v1.2（计划中）

- [ ] 集成飞书/钉钉日历同步
- [ ] 支持项目模板（客户项目/课程项目）
- [ ] 工作记录可视化统计

### v2.0（规划中）

- [ ] 多语言支持（英文、日文）
- [ ] Web UI 配置界面
- [ ] 团队协作模式

## 贡献指南

### 代码规范

- SKILL.md 使用 Markdown 格式
- 保持单一职责原则
- 每个功能都要有对应的示例

### 提交 PR 流程

1. Fork 仓库
2. 创建特性分支
3. 编写代码和测试
4. 更新文档
5. 提交 PR

### 文档要求

每个新功能必须包含：
- README.md 中的功能说明
- SKILL.md 中的实现步骤
- examples/ 中的使用案例

## 联系方式

- GitHub Issues
- Discord: Claude Code 频道
- Email: your@email.com
