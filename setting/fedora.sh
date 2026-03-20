#!/usr/bin/env bash

#============================================================
# File: fedora.sh
# Description: 导入 Fedora GPG 密钥
# URL: https://fedoraproject.org/
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

# https://src.fedoraproject.org/rpms/fedora-repos/raw/main/f/RPM-GPG-KEY-fedora-43-primary
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-43-primary
