#!/usr/bin/env bash

if [[ ! -f "$HOME/.gvm/env" ]]; then
    curl -L https://fx4.cn/golang | bash

    # shellcheck disable=SC1091
    . "$HOME/.gvm/env"

    gvm use latest    
fi
