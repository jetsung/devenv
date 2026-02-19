#!/usr/bin/env bash

if [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
    echo "ble.sh is already installed"
    exit 0
fi

pushd "/tmp" >/dev/null || exit
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
popd >/dev/null || exit