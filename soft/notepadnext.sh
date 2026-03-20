#!/usr/bin/env bash

#============================================================
# File: notepadnext.sh
# Description: 下载 NotepadNext 编辑器 AppImage
# URL: https://github.com/dail8859/NotepadNext
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-03
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
readonly NC='\033[0m' # No Color

pkg_file="/tmp/NotepadNext.AppImage"

# 打印带颜色的消息
print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

# 主函数
main() {
    # 检查 curl 是否安装
    if ! command -v curl &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 curl"
        exit 1
    fi

    repo_api_url="https://api.github.com/repos/dail8859/NotepadNext/releases/latest"
    download_url=$(curl -fsSL "$repo_api_url" | jq -r '.assets[] | select(.name | test("AppImage")) | .browser_download_url')

    print_msg "$YELLOW" "NotepadNext: https://github.com/dail8859/NotepadNext/releases"
    if curl --progress-bar -fsSL -o "$pkg_file" "$download_url"; then
        print_msg "$GREEN" "下载成功: $download_url"
        print_msg "$GREEN" "NotepadNext AppImage 文件位于 $pkg_file"
    else
        print_msg "$RED" "下载失败，请检查网络连接"
        exit 1
    fi

}

main "$@"
