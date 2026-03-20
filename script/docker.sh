#!/usr/bin/env bash

#============================================================
# File: docker.sh
# Description: 安装 Docker 容器引擎
# URL: https://www.docker.com/
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

curl -L https://get.docker.com | bash -s -- --mirror Aliyun

dockerd-rootless-setuptool.sh install