#!/usr/bin/env bash

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    pushd "$HOME/.oh-my-zsh" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    pushd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    pushd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" >/dev/null || exit
    git pull
    popd >/dev/null || exit
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

sed -i 's#^plugins=(git)#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)#' "$HOME/.zshrc"
