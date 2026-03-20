#!/usr/bin/env bash

#============================================================
# File: trae.sh
# Description: 安装 Trae AI 编程助手
# URL: https://www.trae.ai/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-20
# UpdatedAt: 2026-03-20
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

readonly TRAE_DESC="Trae Linux版"

readonly DOWNLOAD_API_GLOBAL="https://api.trae.ai/icube/api/v1/native/version/trae/latest"
readonly DOWNLOAD_API_CN="https://api.trae.ai/icube/api/v1/native/version/trae/cn/latest"

# 默认安装国际版
USE_CN=false

usage() {
    echo "用法: $0 [选项]"
    echo
    echo "选项:"
    echo "  -c, --cn    安装中国版 (默认安装国际版)"
    echo "  -h, --help  显示帮助信息"
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--cn)
                USE_CN=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                print_msg "$RED" "错误: 未知选项 $1"
                usage
                ;;
        esac
    done
}

get_download_api() {
    if [[ "$USE_CN" == true ]]; then
        echo "$DOWNLOAD_API_CN"
    else
        echo "$DOWNLOAD_API_GLOBAL"
    fi
}

# 缓存版本信息
VERSION_INFO=""

get_version_info() {
    if [[ -z "$VERSION_INFO" ]]; then
        local api
        api=$(get_download_api)
        VERSION_INFO=$(curl -fsSL "$api") || {
            print_msg "$RED" "获取版本信息失败"
            exit 1
        }
    fi
    echo "$VERSION_INFO"
}

get_latest_version() {
    local info
    info=$(get_version_info)
    echo "$info" | jq -r '.data.manifest.linux.download[0]["x64.deb"]' | grep -oP 'stable/\K[0-9.]+'
}

get_download_url() {
    local arch=$1
    local pkg_type=$2
    local info
    info=$(get_version_info)

    case "$arch" in
        x86_64|amd64)
            case "$pkg_type" in
                rpm) echo "$info" | jq -r '.data.manifest.linux.download[0]["x64.rpm"]' ;;
                deb) echo "$info" | jq -r '.data.manifest.linux.download[0]["x64.deb"]' ;;
            esac
            ;;
        aarch64|arm64)
            case "$pkg_type" in
                rpm) echo "$info" | jq -r '.data.manifest.linux.download[0]["arm64.rpm"]' ;;
                deb) echo "$info" | jq -r '.data.manifest.linux.download[0]["arm64.deb"]' ;;
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
    rm -f /tmp/trae.rpm /tmp/trae.deb
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

install_trae() {
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

    local edition
    if [[ "$USE_CN" == true ]]; then
        edition="中国版"
    else
        edition="国际版"
    fi

    print_msg "$GREEN" "https://www.trae.ai/"
    echo

    print_msg "$YELLOW" "安装版本: $edition"
    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            download_url=$(get_download_url "$arch_rpm" "rpm")
            pkg_file="/tmp/trae.rpm"
            print_msg "$YELLOW" "正在下载 Trae $edition RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                if rpm -q trae &>/dev/null; then
                    print_msg "$YELLOW" "检测到 Trae 已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "Trae 更新成功！"
                else
                    print_msg "$YELLOW" "正在安装 Trae..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "Trae 安装成功！"
                fi
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            download_url=$(get_download_url "$arch_deb" "deb")
            pkg_file="/tmp/trae.deb"
            print_msg "$YELLOW" "正在下载 Trae $edition DEB 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "Trae 安装成功！"
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

    parse_args "$@"

    local edition
    if [[ "$USE_CN" == true ]]; then
        edition="中国版"
    else
        edition="国际版"
    fi

    print_msg "$GREEN" "=== $TRAE_DESC ($edition) 安装脚本 ==="
    echo

    install_trae
}

main "$@"
