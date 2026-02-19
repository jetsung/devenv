#!/usr/bin/env bash

if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ -f "$HOME/.config/nvim/lazyvim.json" ]]; then
        pushd "$HOME/.config/nvim" >/dev/null || exit
        git pull
        popd >/dev/null || exit
    else
        mv "$HOME"/.config/nvim{,.bak}
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

        mv "$HOME"/.local/share/nvim{,.bak}
        mv "$HOME"/.local/state/nvim{,.bak}
        mv "$HOME"/.cache/nvim{,.bak}        
    fi
else
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
fi