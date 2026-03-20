#!/usr/bin/env bash

#============================================================
# File: ollama.sh
# Description: 安装 Ollama 本地大模型运行工具
# URL: https://ollama.com/
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

curl -L https://fx4.cn/x | bash -s -- https://ollama.com/install.sh | bash
