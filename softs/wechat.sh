#!/usr/bin/env bash

set -euo pipefail

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
    rm -f /tmp/wechat.rpm /tmp/wechat.deb
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

# 下载并安装微信
install_wechat() {
    local arch
    arch=$(detect_arch)
    local pkg_type
    pkg_type=$(detect_package_manager)
    local download_url
    local pkg_file

    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            download_url="https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_${arch}.rpm"
            pkg_file="/tmp/wechat.rpm"
            print_msg "$YELLOW" "正在下载微信 RPM 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo rpm -i "$pkg_file"
                print_msg "$GREEN" "微信安装成功！"
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            download_url="https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_${arch}.deb"
            pkg_file="/tmp/wechat.deb"
            print_msg "$YELLOW" "正在下载微信 DEB 包..."
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt-get install -f -y
                print_msg "$GREEN" "微信安装成功！"
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

    install_wechat
}

main "$@"