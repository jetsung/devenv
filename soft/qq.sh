#!/usr/bin/env bash

#============================================================
# File: qq.sh
# Description: 安装腾讯 QQ Linux 客户端
# URL: https://im.qq.com/
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

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

readonly QQ_DESC="腾讯QQ Linux版"

readonly DOWNLOAD_API="https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/pcConfig.json"

get_latest_version() {
    local info
    info=$(curl -fsSL "$DOWNLOAD_API") || {
        print_msg "$RED" "获取版本信息失败"
        exit 1
    }
    echo "$info" | jq -r '.Linux.version'
}

get_download_url() {
    local arch=$1
    local pkg_type=$2
    local info
    info=$(curl -fsSL "$DOWNLOAD_API") || {
        print_msg "$RED" "获取版本信息失败"
        exit 1
    }

    case "$arch" in
        x86_64)
            case "$pkg_type" in
                rpm) echo "$info" | jq -r '.Linux.x64DownloadUrl.rpm' ;;
                deb) echo "$info" | jq -r '.Linux.x64DownloadUrl.deb' ;;
            esac
            ;;
        aarch64|arm64)
            case "$pkg_type" in
                rpm) echo "$info" | jq -r '.Linux.armDownloadUrl.rpm' ;;
                deb) echo "$info" | jq -r '.Linux.armDownloadUrl.deb' ;;
            esac
            ;;
    esac
}

print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

cleanup() {
    rm -f /tmp/qq.rpm /tmp/qq.deb
}

trap cleanup EXIT

detect_arch() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            print_msg "$RED" "错误: 不支持的架构: $arch"
            exit 1
            ;;
    esac
}

detect_arch_for_rpm() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        *)
            print_msg "$RED" "错误: 不支持的架构: $arch"
            exit 1
            ;;
    esac
}

detect_arch_for_deb() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            print_msg "$RED" "错误: 不支持的架构: $arch"
            exit 1
            ;;
    esac
}

detect_package_manager() {
    if command -v rpm &>/dev/null && command -v dnf &>/dev/null; then
        echo "rpm"
    elif command -v dpkg &>/dev/null && command -v apt &>/dev/null; then
        echo "deb"
    else
        echo "unknown"
    fi
}

install_qq() {
    local arch
    arch=$(detect_arch)
    local arch_rpm
    arch_rpm=$(detect_arch_for_rpm)
    local arch_deb
    arch_deb=$(detect_arch_for_deb)
    local pkg_type
    pkg_type=$(detect_package_manager)
    local download_url
    local pkg_file
    local qq_version
    qq_version=$(get_latest_version)

    print_msg "$GREEN" "https://im.qq.com/index/"
    echo

    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"
    print_msg "$YELLOW" "最新版本: $qq_version"

    case "$pkg_type" in
        rpm)
            download_url=$(get_download_url "$arch_rpm" "rpm")
            pkg_file="/tmp/qq.rpm"
            print_msg "$YELLOW" "正在下载 QQ RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                if rpm -q qq &>/dev/null; then
                    print_msg "$YELLOW" "检测到 QQ 已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "QQ 更新成功！"
                else
                    print_msg "$YELLOW" "正在安装 QQ..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "QQ 安装成功！"
                fi
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            download_url=$(get_download_url "$arch_deb" "deb")
            pkg_file="/tmp/qq.deb"
            print_msg "$YELLOW" "正在下载 QQ DEB 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "QQ 安装成功！"
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

    local qq_version
    qq_version=$(get_latest_version)

    print_msg "$GREEN" "=== $QQ_DESC 安装脚本 ==="
    print_msg "$GREEN" "版本: $qq_version"
    echo

    install_qq
}

main "$@"
