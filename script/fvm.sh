#!/usr/bin/env bash

#============================================================
# File: fvm.sh
# Description: flutter 版本管理器
# URL: 
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-30
# UpdatedAt: 2026-03-30
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

get_latest_release() {
    curl -sL fx4.cn/x | bash -s -- "https://api.github.com/repos/leoafarias/fvm/releases/latest" | grep '"tag_name":' | cut -d'"' -f4
}

main() {
    _version=${1:-$(get_latest_release)}
    curl -L fx4.cn/x | bash -s -- https://fvm.app/install.sh | bash -s -- "${1:-$(get_latest_release)}"
}

main "$@"