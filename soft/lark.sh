#!/usr/bin/env bash

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly LARK_DESC="飞书 Linux版"

readonly DOWNLOAD_API_BASE="https://www.larksuite.com/api/package_info"

get_latest_version() {
    local platform=$1
    local info
    info=$(curl -fsSL "$DOWNLOAD_API_BASE?platform=$platform") || {
        print_msg "$RED" "获取版本信息失败"
        exit 1
    }
    echo "$info" | jq -r '.data.version_number'
}

get_download_url() {
    local platform=$1
    local info
    info=$(curl -fsSL "$DOWNLOAD_API_BASE?platform=$platform") || {
        print_msg "$RED" "获取版本信息失败"
        exit 1
    }
    echo "$info" | jq -r '.data.download_link'
}

print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

cleanup() {
    rm -f /tmp/lark.rpm /tmp/lark.deb
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

get_platform() {
    local arch=$1
    local pkg_type=$2

    case "$arch" in
        x86_64)
            case "$pkg_type" in
                rpm) echo "11" ;;
                deb) echo "10" ;;
            esac
            ;;
        aarch64|arm64)
            case "$pkg_type" in
                rpm) echo "13" ;;
                deb) echo "12" ;;
            esac
            ;;
    esac
}

install_lark() {
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
    local lark_version

    case "$pkg_type" in
        rpm)
            lark_version=$(get_latest_version "11")
            ;;
        deb)
            lark_version=$(get_latest_version "10")
            ;;
    esac

    print_msg "$GREEN" "https://www.larksuite.com/zh_cn/download?from=navbar"
    echo

    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"
    print_msg "$YELLOW" "最新版本: $lark_version"

    case "$pkg_type" in
        rpm)
            local platform
            platform=$(get_platform "$arch_rpm" "rpm")
            download_url=$(get_download_url "$platform")
            pkg_file="/tmp/lark.rpm"
            print_msg "$YELLOW" "正在下载飞书 RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                if rpm -q Lark &>/dev/null; then
                    print_msg "$YELLOW" "检测到飞书已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "飞书更新成功！"
                else
                    print_msg "$YELLOW" "正在安装飞书..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "飞书安装成功！"
                fi
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            local platform
            platform=$(get_platform "$arch_deb" "deb")
            download_url=$(get_download_url "$platform")
            pkg_file="/tmp/lark.deb"
            print_msg "$YELLOW" "正在下载飞书 DEB 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "飞书安装成功！"
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

    local lark_version
    lark_version=$(get_latest_version "10")

    print_msg "$GREEN" "=== $LARK_DESC 安装脚本 ==="
    print_msg "$GREEN" "版本: $lark_version"
    echo

    install_lark
}

main "$@"
