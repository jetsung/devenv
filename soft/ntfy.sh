#!/usr/bin/env bash

#============================================================
# File: ntfy.sh
# Description: 安装 ntfy HTTP-based pub-sub 消息通知服务
# URL: https://github.com/binwiederhier/ntfy
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.2.0
# CreatedAt: 2026-03-24
# UpdatedAt: 2026-03-24
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

# 打印带颜色的消息
print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

# 检测系统架构
detect_arch() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        armv7l) echo "armv7" ;;
        armv6l) echo "armv6" ;;
        *) echo "$arch" ;;
    esac
}

# 检测包管理器类型
detect_package_manager() {
    if command -v dnf &>/dev/null; then
        echo "rpm"
    elif command -v apt-get &>/dev/null; then
        echo "deb"
    else
        echo "unknown"
    fi
}

install_ntfy() {
    local pkg_file=$1
    local pkg_type=$2

    print_msg "$YELLOW" "正在安装 ntfy..."

    case "$pkg_type" in
        rpm)
            sudo dnf install -y "$pkg_file"
            ;;
        deb)
            sudo dpkg -i "$pkg_file" || sudo apt-get install -f -y
            ;;
    esac
}

# 主函数
main() {
    # 检查 curl 和 jq 是否安装
    if ! command -v curl &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 curl"
        exit 1
    fi
    if ! command -v jq &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 jq"
        exit 1
    fi

    local arch pkg_type
    arch=$(detect_arch)
    pkg_type=$(detect_package_manager)

    if [[ "$pkg_type" == "unknown" ]]; then
        print_msg "$RED" "错误: 无法检测到支持的包管理器 (需要 dnf 或 apt)"
        exit 1
    fi

    print_msg "$YELLOW" "检测到架构: $arch, 包格式: $pkg_type"

    local repo_api_url="https://api.github.com/repos/binwiederhier/ntfy/releases/latest"
    local download_url
    
    # 从 GitHub API 获取下载地址
    download_url=$(curl -fsSL "$repo_api_url" | jq -r ".assets[] | select(.name | test(\"linux_${arch}\\\\.${pkg_type}$\")) | .browser_download_url")

    if [[ -z "$download_url" || "$download_url" == "null" ]]; then
        print_msg "$RED" "错误: 无法找到适用于 $arch 的 $pkg_type 安装包"
        exit 1
    fi

    local pkg_filename
    pkg_filename=$(basename "$download_url")
    local pkg_path="/tmp/$pkg_filename"

    print_msg "$YELLOW" "下载地址: $download_url"
    if curl -fsSL -o "$pkg_path" "$download_url"; then
        print_msg "$GREEN" "下载完成，正在安装..."
        install_ntfy "$pkg_path" "$pkg_type"
        rm -f "$pkg_path"
        print_msg "$GREEN" "ntfy 安装成功！"
    else
        print_msg "$RED" "下载失败，请检查网络连接"
        exit 1
    fi
}

main "$@"
