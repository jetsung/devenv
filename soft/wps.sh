#!/usr/bin/env bash

#============================================================
# File: wps.sh
# Description: 安装 WPS Office Linux 版
# URL: https://www.wps.cn/product/wpslinux
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-13
# UpdatedAt: 2026-03-13
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly WPS_DESC="WPS Office Linux版"
readonly WPS_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
readonly WPS_SECRET="7f8faaaa468174dc1c9cd62e5f218a5b"

print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

cleanup() {
    rm -f /tmp/wps.rpm /tmp/wps.deb
}

trap cleanup EXIT

detect_package_manager() {
    if command -v rpm &>/dev/null && command -v dnf &>/dev/null; then
        echo "rpm"
    elif command -v dpkg &>/dev/null && command -v apt &>/dev/null; then
        echo "deb"
    else
        echo "unknown"
    fi
}

get_download_url() {
    local pkg_type=$1
    local pkg_html
    pkg_html=$(curl -fsSL -A "$WPS_UA" "https://www.wps.cn/product/wpslinux")
    
    case "$pkg_type" in
        rpm)
            echo "$pkg_html" | grep -oE 'https?://[^"<>]+\.rpm' | head -1
            ;;
        deb)
            echo "$pkg_html" | grep -oE 'https?://[^"<>]+\.deb' | head -1
            ;;
    esac
}

sign_url() {
    local url=$1
    local timestamp
    timestamp=$(date +%s)
    local uri
    uri=$(echo "$url" | sed -n 's|https://[^/]*\(.*\)|\1|p')
    local md5hash
    md5hash=$(echo -n "${WPS_SECRET}${uri}${timestamp}" | md5sum | cut -d' ' -f1)
    echo "${url}?t=${timestamp}&k=${md5hash}"
}

install_wps() {
    local pkg_type
    pkg_type=$(detect_package_manager)
    local download_url
    local signed_url
    local pkg_file

    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            download_url=$(get_download_url "rpm")
            signed_url=$(sign_url "$download_url")
            pkg_file="/tmp/wps.rpm"
            print_msg "$YELLOW" "正在下载 WPS RPM 包..."
            if curl -fsSL -A "$WPS_UA" -o "$pkg_file" "$signed_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                if rpm -q wps-office &>/dev/null; then
                    print_msg "$YELLOW" "检测到 WPS 已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "WPS 更新成功！"
                else
                    print_msg "$YELLOW" "正在安装 WPS..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "WPS 安装成功！"
                fi
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            download_url=$(get_download_url "deb")
            signed_url=$(sign_url "$download_url")
            pkg_file="/tmp/wps.deb"
            print_msg "$YELLOW" "正在下载 WPS DEB 包..."
            if curl -fsSL -A "$WPS_UA" -o "$pkg_file" "$signed_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "WPS 安装成功！"
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        *)
            print_msg "$RED" "错误: 无法检测到支持的包管理器 (需要 dnf/rpm 或 apt/dpkg)"
            exit 1
            ;;
    esac
}

main() {
    if ! command -v curl &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 curl"
        exit 1
    fi

    print_msg "$GREEN" "=== $WPS_DESC 安装脚本 ==="
    echo

    install_wps
}

main "$@"
