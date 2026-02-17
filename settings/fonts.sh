#!/usr/bin/env bash

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

FONT_DIR="/usr/share/fonts/custom"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Creating global font directory..."
sudo mkdir -p "$FONT_DIR"

download_and_install() {
    local name="$1"
    local url="$2"
    local ext="${3:-zip}"
    
    echo "Installing font: $name..."
    
    local archive="$TEMP_DIR/$name.$ext"
    
    if ! curl -fsSL --location "$url" -o "$archive"; then
        echo "Error: Failed to download $name" >&2
        return 1
    fi
    
    local extract_dir="$TEMP_DIR/$name"
    mkdir -p "$extract_dir"
    
    case "$ext" in
        zip)
            unzip -q "$archive" -d "$extract_dir"
            ;;
        tar.xz)
            tar -xf "$archive" -C "$extract_dir"
            ;;
        *)
            echo "Error: Unknown archive format: $ext" >&2
            return 1
            ;;
    esac
    
    sudo find "$extract_dir" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$FONT_DIR/" \;
    
    echo "Font $name installed successfully"
}

# https://www.jetbrains.com/lp/mono/
download_and_install "JetBrainsMono" \
    "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip" "zip"

# https://github.com/tonsky/FiraCode
download_and_install "FiraCode" \
    "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" "zip"

# https://github.com/ryanoasis/nerd-fonts/releases
download_and_install "JetBrainsMono-Nerd" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz" "tar.xz"

# https://fonts.google.com/noto/specimen/Noto+Sans+Mono
# https://github.com/notofonts/latin-greek-cyrillic
download_and_install "NotoSansMono" \
    "https://github.com/notofonts/latin-greek-cyrillic/releases/download/NotoSansMono-v2.014/NotoSansMono-v2.014.zip" "zip"

echo "Updating global font cache..."
sudo fc-cache -fv

echo "JetBrains Mono,Fira Code,JetBrainsMono Nerd Font Mono,Noto Sans Mono"
echo "All fonts installed successfully to $FONT_DIR!"
