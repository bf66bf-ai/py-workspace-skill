#!/bin/bash
# py-workspace skill 发布脚本
# 使用方法：在 GitHub 创建好仓库后，运行此脚本

echo "=== py-workspace Skill 发布脚本 ==="
echo ""
echo "前提条件："
echo "1. 你已经在 GitHub 网页创建了仓库 py-workspace-skill"
echo "2. 仓库是 Public（公开）"
echo "3. 没有勾选 README、.gitignore 或 license"
echo ""
read -p "确认已创建仓库？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "请先去 https://github.com/new 创建仓库"
    exit 1
fi

echo ""
echo "开始推送..."
echo ""

cd "/e/桌面/拼音的Codex工作区/tmp/workspace-manager-skill"

# 检查是否已有 origin
if git remote | grep -q "origin"; then
    echo "删除已有的 origin..."
    git remote remove origin
fi

# 添加远程仓库
echo "添加远程仓库..."
git remote add origin https://github.com/pinyin/py-workspace-skill.git

# 推送到 GitHub
echo "推送代码到 GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "📍 仓库地址："
    echo "https://github.com/pinyin/py-workspace-skill"
    echo ""
    echo "⏭️ 下一步：创建 Release"
    echo "1. 访问 https://github.com/pinyin/py-workspace-skill/releases/new"
    echo "2. Tag version: v1.0.0"
    echo "3. 复制 .github-release-template.md 的内容"
    echo "4. 点击 Publish release"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. 仓库还没创建"
    echo "2. 需要 GitHub 登录认证"
    echo "3. 网络连接问题"
    echo ""
    echo "如果需要认证，会弹出登录窗口"
fi
