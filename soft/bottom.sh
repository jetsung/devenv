#!/usr/bin/env bash

#============================================================
# File: bottom.sh
# Description: 安装 bottom (系统监控工具)
# URL: https://github.com/ClementTsang/bottom
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.2.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-22
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
        x86_64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        armv7l)
            echo "armv7"
            ;;
        *)
            echo "$arch"
            ;;
    esac
}

# 检测包管理器类型
detect_package_manager() {
    if command -v rpm &>/dev/null && command -v dnf &>/dev/null; then
        echo "rpm"
    elif command -v dpkg &>/dev/null && command -v apt &>/dev/null; then
        echo "deb"
    else
        echo "unknown"
    fi
}

# 获取下载链接
get_download_url() {
    local pkg_type=$1
    local arch=$2
    local repo_api_url="https://api.github.com/repos/ClementTsang/bottom/releases/latest"

    # 根据包类型和架构构建匹配模式
    local pattern
    case "$pkg_type" in
        rpm)
            pattern="bottom-musl.*${arch}.*rpm"
            ;;
        deb)
            if [[ "$arch" = "x86_64" ]]; then
                arch="amd64"
            fi
            pattern="bottom-musl.*${arch}.*deb"
            ;;
        *)
            # 默认下载 musl 版本的 tar.gz
            pattern="bottom-*musl.*${arch}.*tar.gz"
            ;;
    esac

    local url
    url=$(curl -fsSL "$repo_api_url" | jq -r "[.assets[] | select(.name | test(\"$pattern\"; \"i\"))][0].browser_download_url" 2>/dev/null)
    echo "$url"
}

# 安装 bottom
install_bottom() {
    local pkg_type=$1
    local pkg_file=$2

    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            sudo dnf install -y "$pkg_file"
            ;;
        deb)
            sudo dpkg -i "$pkg_file" || sudo apt install -f -y
            ;;
        *)
            print_msg "$RED" "错误: 无法检测到支持的包管理器 (需要 dnf/rpm 或 apt/dpkg)"
            exit 1
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

    # 检测系统和架构
    local pkg_type arch download_url pkg_file
    pkg_type=$(detect_package_manager)
    arch=$(detect_arch)

    print_msg "$YELLOW" "检测到系统架构: $arch"

    # 获取下载链接
    download_url=$(get_download_url "$pkg_type" "$arch")

    if [[ -z "$download_url" || "$download_url" == "null" ]]; then
        print_msg "$RED" "错误: 无法获取下载链接，请检查网络连接或架构支持"
        exit 1
    fi

    print_msg "$GREEN" "下载链接: $download_url"

    # 根据包类型确定文件路径
    case "$pkg_type" in
        rpm)
            pkg_file="/tmp/bottom-${arch}.rpm"
            ;;
        deb)
            pkg_file="/tmp/bottom_${arch}.deb"
            ;;
        *)
            pkg_file="/tmp/bottom.tar.gz"
            ;;
    esac

    # 下载文件
    print_msg "$YELLOW" "正在下载 bottom..."
    if ! curl -fsSL -o "$pkg_file" "$download_url"; then
        print_msg "$RED" "下载失败，请检查网络连接"
        rm -f "$pkg_file"
        exit 1
    fi

    # 验证下载文件
    if [[ ! -s "$pkg_file" ]]; then
        print_msg "$RED" "下载文件为空或损坏"
        rm -f "$pkg_file"
        exit 1
    fi

    print_msg "$GREEN" "下载完成，正在安装..."

    # 安装
    if [[ "$pkg_type" == "unknown" ]]; then
        # 未知包管理器，使用二进制安装
        local install_dir="$HOME/.local/bin"
        mkdir -p "$install_dir"
        tar -xzf "$pkg_file" -C /tmp
        local bottom_bin
        bottom_bin=$(find /tmp -type f -name "btm" -o -name "bottom" 2>/dev/null | head -1)
        if [[ -n "$bottom_bin" ]]; then
            cp "$bottom_bin" "$install_dir/"
            bottom_path="$install_dir/$(basename "$bottom_bin")"
            chmod +x "$bottom_path"
            print_msg "$GREEN" "bottom 安装成功！安装路径: $bottom_path"
        else
            print_msg "$RED" "错误: 无法找到 bottom 二进制文件"
            rm -f "$pkg_file"
            exit 1
        fi
    else
        install_bottom "$pkg_type" "$pkg_file"
        print_msg "$GREEN" "bottom 安装成功！"
    fi

    # 清理
    rm -f "$pkg_file"
    print_msg "$GREEN" "清理完成"
}

main "$@"
