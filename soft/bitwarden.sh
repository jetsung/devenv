#!/usr/bin/env bash

#============================================================
# File: bitwarden.sh
# Description: 安装 Bitwarden 密码管理器
# URL: https://bitwarden.com/download/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
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

readonly BITWARDEN_DESC="Bitwarden 密码管理器"
readonly REPO_API_BASE="https://api.github.com/repos/bitwarden/clients/releases"

print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

cleanup() {
    rm -f /tmp/bitwarden.rpm /tmp/bitwarden.deb
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

get_latest_version() {
    curl -fsSL "$REPO_API_BASE" | jq -r '.[] | select(.tag_name | startswith("desktop-")) | .tag_name' | head -1
}

get_download_url() {
    local version=$1
    local pkg_type=$2
    curl -fsSL "$REPO_API_BASE/tags/$version" | jq -r ".assets[] | select(.name | test(\".*${pkg_type}$\"; \"i\")) | .browser_download_url"
}

install_bitwarden() {
    local pkg_type
    pkg_type=$(detect_package_manager)
    local download_url
    local pkg_file

    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            download_url=$(get_download_url "$latest_version" "rpm")
            pkg_file="/tmp/bitwarden.rpm"
            print_msg "$YELLOW" "正在下载 Bitwarden RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                if rpm -q Bitwarden &>/dev/null; then
                    print_msg "$YELLOW" "检测到 Bitwarden 已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "Bitwarden 更新成功！"
                else
                    print_msg "$YELLOW" "正在安装 Bitwarden..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "Bitwarden 安装成功！"
                fi
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            download_url=$(get_download_url "$latest_version" "deb")
            pkg_file="/tmp/bitwarden.deb"
            print_msg "$YELLOW" "正在下载 Bitwarden DEB 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "Bitwarden 安装成功！"
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

    if ! command -v jq &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 jq"
        exit 1
    fi

    latest_version=$(get_latest_version)

    print_msg "$GREEN" "=== $BITWARDEN_DESC 安装脚本 ==="
    print_msg "$GREEN" "版本: $latest_version"
    echo
    print_msg "$YELLOW" "https://bitwarden.com/download/"

    install_bitwarden
}

main "$@"
