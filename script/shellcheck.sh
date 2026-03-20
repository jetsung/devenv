#!/usr/bin/env bash

#============================================================
# File: shellcheck.sh
# Description: 安装 ShellCheck 静态分析工具
# URL: https://www.shellcheck.net/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-03
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

curl -L https://fx4.cn/shellcheck | bash
