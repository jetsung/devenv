#!/usr/bin/env bash

# shellcheck disable=SC1091
if [[ -f .env ]]; then
    source ./.env
fi

curl -L fx4.cn/just | bash
