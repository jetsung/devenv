#!/usr/bin/env bash

set -euo pipefail

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

  # 卸载 vi
  sudo dnf remove vim-minimal -y

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

