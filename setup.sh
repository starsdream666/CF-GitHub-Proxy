#!/usr/bin/env bash
# ============================================================
# CF-GitHub-Proxy 一键配置脚本 (Linux / macOS / Git Bash)
#
# 用法:
#   ./setup.sh <你的代理域名>
#
# 示例:
#   ./setup.sh sgh.cfwork.cc.cd
#   ./setup.sh ghfile.geekertao.top
#
# 效果: clone/pull 走代理加速，push 自动直连 GitHub
# ============================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请提供代理域名${NC}"
    echo "用法: $0 <你的代理域名>"
    echo "示例: $0 sgh.cfwork.cc.cd"
    exit 1
fi

DOMAIN="$1"
# 去掉可能误输入的 https:// 前缀和尾部斜杠
DOMAIN="${DOMAIN#https://}"
DOMAIN="${DOMAIN#http://}"
DOMAIN="${DOMAIN%/}"

PROXY_URL="https://${DOMAIN}/https://github.com/"

echo -e "${YELLOW}配置 git pushInsteadOf:${NC}"
echo "  代理: ${PROXY_URL}"
echo "  → push 自动替换为: https://github.com/"
echo "  → clone/pull 不受影响，继续走代理加速"

git config --global url."https://github.com/".pushInsteadOf "${PROXY_URL}"

echo -e "${GREEN}✓ 配置完成!${NC}"
echo ""
echo "现在可以这样使用:"
echo "  git clone https://${DOMAIN}/https://github.com/用户/仓库.git  # 走代理加速"
echo "  cd 仓库"
echo "  # git pull → 走代理加速 ✅"
echo "  # git push → 自动直连 GitHub，无需额外操作 ✅"
