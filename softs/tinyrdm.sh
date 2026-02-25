#!/usr/bin/env bash

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

pkg_file="/tmp/tinyrdm.deb"

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

install_tinyrdm() {
    local pkg_type
    pkg_type=$(detect_package_manager)

    print_msg "$YELLOW" "检测到包管理器: $pkg_type"

    case "$pkg_type" in
        rpm)
            pushd /tmp >/dev/null || exit
            deb2rpm.sh "$pkg_file" ./tinyrdm && tinyrdm_path=$(find ./tinyrdm -type f -name "*.rpm") && sudo rpm -i "$tinyrdm_path"
            popd >/dev/null || exit
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
    # 检查 curl 是否安装
    if ! command -v curl &>/dev/null; then
        print_msg "$RED" "错误: 需要安装 curl"
        exit 1
    fi

    repo_api_url="https://api.github.com/repos/tiny-craft/tiny-rdm/releases/latest"
    download_url=$(curl -fsSL "$repo_api_url" | jq -r '.assets[] | select(.name | test("webkit2")) | .browser_download_url')

    print_msg "$YELLOW" "TinyRDM: https://github.com/tiny-craft/tiny-rdm/releases"
    if curl -fsSL -o "$pkg_file" "$download_url"; then
        print_msg "$GREEN" "下载完成，正在安装..."
        install_tinyrdm
        print_msg "$GREEN" "TinyRDM 安装成功！"
    else
        print_msg "$RED" "下载失败，请检查网络连接"
        exit 1
    fi

}

main "$@"
