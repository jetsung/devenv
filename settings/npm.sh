#!/usr/bin/env bash

if ! command -v npm &> /dev/null; then
    echo "提示: 未安装 npm，请先安装 Node.js"
    exit 0
fi

npm config set registry https://registry.npmmirror.com