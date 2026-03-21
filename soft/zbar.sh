#!/usr/bin/env bash

#============================================================
# File: zbar.sh
# Description: 
# URL: https://github.com/mchehab/zbar
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

# 清理临时文件
cleanup() {
    rm -f /tmp/zbar.rpm /tmp/zbar.deb
}

# 设置清理钩子
trap cleanup EXIT

# 检测系统架构
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

# 下载并安装ZBar
install_zbar() {
    local arch
    arch=$(detect_arch)
    local pkg_type
    pkg_type=$(detect_package_manager)
    local download_url
    local pkg_file

    print_msg "$GREEN" "https://zbar.sourceforge.net/"
    echo

    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    # shellcheck disable=SC1091
    . /etc/os-release

    case "$pkg_type" in
        rpm)
            html_url="https://rpmfind.net/linux/rpm2html/search.php?query=zbar&submit=Search+...&system=${ID}_${VERSION_ID}&arch=${arch}"
            
            # 从源代码页面中提取包含 releases 的链接
            local releases_page
            releases_page=$(curl -s -L "$html_url")
            
            # 提取包含 releases 的链接 (支持单引号和双引号)
            local releases_link
            releases_link=$(echo "$releases_page" | grep -oE "href='[^']+releases[^']+'")
            if [[ -z "$releases_link" ]]; then
                releases_link=$(echo "$releases_page" | grep -oE 'href="[^"]+releases[^"]+"')
            fi
            download_url=$(echo "$releases_link" | sed -e "s/href='//;s/'//" -e 's/href="//;s/"//')
            
            if [[ -z "$download_url" ]]; then
                print_msg "$RED" "错误: 无法找到包含 releases 的链接"
                exit 1
            fi

            # 如果是相对链接，转换为绝对链接
            if [[ "$download_url" != http* ]]; then
                download_url="https://rpmfind.net${download_url}"
            fi
            
            pkg_file="/tmp/zbar.rpm"
            print_msg "$YELLOW" "正在下载ZBar RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在检查安装状态..."
                # 检查是否已安装ZBar
                if rpm -q zbar &>/dev/null; then
                    print_msg "$YELLOW" "检测到ZBar已安装，正在更新..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "ZBar更新成功！"
                else
                    print_msg "$YELLOW" "正在安装ZBar..."
                    sudo dnf install -y "$pkg_file"
                    print_msg "$GREEN" "ZBar安装成功！"
                fi
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

# 主函数
main() {
    # 检查 curl 是否安装
    if ! command -v curl &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 curl"
        exit 1
    fi

    install_zbar
}

main "$@"