#!/usr/bin/env bash

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
    rm -f "$pkg_file"
}

# 设置清理钩子
trap cleanup EXIT

# 检测系统架构
detect_arch() {
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

# 安装 MQTTX
install_mqttx() {
    local pkg_type=$1
    local download_url=$2
    local pkg_file

    print_msg "$GREEN" "https://mqttx.app/zh/downloads"
    echo
    
    print_msg "$YELLOW" "正在下载 MQTTX 安装包..."

    case "$pkg_type" in
        rpm)
            pkg_file="/tmp/mqttx.rpm"
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dnf install -y "$pkg_file"
                print_msg "$GREEN" "MQTTX 安装成功！"
            else
                print_msg "$RED" "下载失败，请检查网络连接"
                exit 1
            fi
            ;;
        deb)
            pkg_file="/tmp/mqttx.deb"
            if curl -fsSL -o "$pkg_file" "$download_url"; then
                print_msg "$GREEN" "下载完成，正在安装..."
                sudo dpkg -i "$pkg_file" || sudo apt install -f -y
                print_msg "$GREEN" "MQTTX 安装成功！"
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

    # 检查 jq 是否安装
    if ! command -v jq &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 jq"
        exit 1
    fi

    local pkg_type
    local arch
    pkg_type=$(detect_package_manager)
    arch=$(detect_arch)

    print_msg "$YELLOW" "检测到架构: $arch"
    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    if [[ "$pkg_type" == "unknown" ]]; then
        print_msg "$RED" "错误: 无法检测到支持的包管理器 (需要 dnf/rpm 或 apt/dpkg)"
        exit 1
    fi

    if [[ "$pkg_type" == "rpm" ]]; then
        if [[ "$arch" = "amd64" ]]; then
            arch="x86_64"
        elif [[ "$arch" = "arm64" ]]; then
            arch="aarch64"
        fi
    fi

    # 获取 MQTTX 最新版本下载链接
    local repo_api_url="https://api.github.com/repos/emqx/MQTTX/releases/latest"
    local download_url
    download_url=$(curl -fsSL "$repo_api_url" | jq -r --arg pkg_type "$pkg_type" --arg arch "$arch" '.assets[] | select(.name | test($pkg_type)) | select(.name | test($arch)) | .browser_download_url' | head -n 1)

    if [[ -z "$download_url" ]]; then
        print_msg "$RED" "错误: 无法找到匹配的 MQTTX 安装包"
        print_msg "$YELLOW" "请访问 https://github.com/emqx/MQTTX/releases 手动下载"
        exit 1
    fi

    print_msg "$GREEN" "找到下载链接: $download_url"
    install_mqttx "$pkg_type" "$download_url"
}

main "$@"
