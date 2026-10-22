#!/usr/bin/env bash
# 一键发布：构建检查 -> 提交 -> 推送
# 用法：
#   ./publish.sh                 # 交互式输入提交说明
#   ./publish.sh "post: 标题"    # 直接指定提交说明
set -euo pipefail

cd "$(dirname "$0")"

echo "==> 1/3 构建检查..."
if ! ./hugo.exe --gc --quiet; then
    echo "!! 构建失败，已中止，未提交任何内容。"
    exit 1
fi
echo "    构建通过"

if [ $# -gt 0 ]; then
    msg="$*"
else
    default="post: 更新博客 $(date '+%Y-%m-%d %H:%M')"
    read -r -p "提交说明（直接回车使用「$default」）: " msg || true
    msg="${msg:-$default}"
fi

git add -A
if git diff --cached --quiet; then
    echo "==> 没有需要提交的改动。"
    exit 0
fi

echo "==> 2/3 提交：$msg"
git commit -q -m "$msg"

echo "==> 3/3 推送到 GitHub..."
git push origin main

echo
echo "完成。约 1 分钟后自动上线："
echo "  https://wyplab.github.io/wypnote/"
