#!/usr/bin/env bash

#============================================================
# File: nvim.sh
# Description: 配置 Neovim 为系统默认编辑器
# URL: https://neovim.io/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-14
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# 打印带颜色的消息
print_msg() {
  local color=$1
  local msg=$2
  echo -e "${color}${msg}${NC}"
}

# 配置 update-alternatives
configure_alternatives() {
  local name=$1
  local path=$2
  local priority=$3

  print_msg "$YELLOW" "配置 $name -> $path (优先级: $priority)"
  sudo update-alternatives --install "$path" "$name" /usr/local/bin/nvim "$priority"
}

# 主函数
main() {
  # 检查 nvim 是否安装
  if [[ ! -f /usr/local/bin/nvim ]]; then
    print_msg "$RED" "错误: /usr/local/bin/nvim 不存在，请先安装 Neovim"
    exit 1
  fi

  # 若是 fedora / rhel 平台需要先删除 vi
  if [[ -f "/etc/redhat-release" ]]; then
    # 卸载 vi
    sudo dnf remove vim-minimal -y
  fi

  # 配置 alternatives
  configure_alternatives "vi" "/usr/bin/vi" 100
  configure_alternatives "editor" "/usr/bin/editor" 100

  # 自动选择 nvim 作为默认 vi
  print_msg "$YELLOW" "设置 nvim 为默认 vi..."
  sudo update-alternatives --set vi /usr/local/bin/nvim || true
  sudo update-alternatives --auto vi

  print_msg "$GREEN" "Neovim 配置完成！"
  print_msg "$GREEN" "当前 vi 指向: $(readlink -f /usr/bin/vi 2>/dev/null || echo '未设置')"
}

main "$@"

