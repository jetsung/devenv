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

# 以 depth=1 克隆仓库到指定目录
clone_repo() {
  local repo_url=$1
  local target_dir=$2
  mkdir -p "$target_dir"
  git clone --depth=1 "$repo_url" "$target_dir"
}

config() {
  local nvim_config nvim_git
  nvim_config="$HOME/.config/nvim"
  nvim_git="https://github.com/jdhao/nvim-config.git"

  if [[ -d "$nvim_config" ]]; then
    # 目录已存在：检查是否为预期仓库，是则更新，否则删除重建
    local remote_url
    remote_url="$(git -C "$nvim_config" remote -v 2>/dev/null | head -1 | awk '{print $2}')"
    if [[ "$remote_url" = "$nvim_git" ]]; then
      print_msg "$YELLOW" "更新 nvim 配置..."
      git -C "$nvim_config" pull origin main
    else
      print_msg "$YELLOW" "仓库不匹配，重新克隆 nvim 配置..."
      rm -rf "$nvim_config"
      clone_repo "$nvim_git" "$nvim_config"
    fi
  else
    # 目录不存在：直接 clone
    print_msg "$YELLOW" "克隆 nvim 配置..."
    clone_repo "$nvim_git" "$nvim_config"
  fi
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

  if [[ "${1:-}" = "config" ]]; then
    config
  fi
}

main "$@"

