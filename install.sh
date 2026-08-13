#!/usr/bin/env bash

# install.sh - Installer script for i3 dotfiles on OpenSUSE

set -euo pipefail

# Style helpers
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}        i3 Dotfiles Installer for OpenSUSE        ${NC}"
echo -e "${BLUE}==================================================${NC}"

# 1. OS verification
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != *"opensuse"* ]]; then
        echo -e "${YELLOW}Warning: This script is configured for OpenSUSE. Detected OS: $NAME.${NC}"
        read -p "Do you want to proceed anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    echo -e "${RED}Error: Cannot detect OS distribution (/etc/os-release missing).${NC}"
    exit 1
fi

# 2. Package installation
echo -e "\n${BLUE}[1/4] Installing dependencies via zypper...${NC}"

PACKAGES=(
    i3
    i3status
    polybar
    rofi
    dunst                    # Tumbleweed: available as 'dunst' via X11:utilities or direct
    picom
    kitty
    feh
    maim
    xclip
    pamixer
    brightnessctl
    playerctl
    polkit-gnome
    NetworkManager-applet    # OpenSUSE uses capital N and M
    # Icon Theme
    papirus-icon-theme
    # Japanese Input Fcitx5
    fcitx5
    fcitx5-mozc
    fcitx5-gtk4
    fcitx5-qt5
    fcitx5-configtool
)

echo -e "This will run: ${YELLOW}sudo zypper install -y${NC} (packages listed above)"
read -p "Would you like to install packages now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo zypper refresh

    # Install packages one by one for better error reporting
    for pkg in "${PACKAGES[@]}"; do
        # Skip comment lines
        [[ "$pkg" == \#* ]] && continue
        # Strip inline comments
        pkg_clean="${pkg%% #*}"
        pkg_clean="${pkg_clean%%  *}"
        [[ -z "$pkg_clean" ]] && continue
        fi
    done
else
    echo -e "${YELLOW}Skipping package installation. Make sure you install dependencies manually.${NC}"
fi


# 3. Create backups and Symlink
echo -e "\n${BLUE}[2/4] Setting up configurations and symlinks...${NC}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

sync_config() {
    local folder=$1
    local source_path="$DOTFILES_DIR/.config/$folder"
    local target_path="$CONFIG_DIR/$folder"

    if [ -d "$target_path" ] || [ -f "$target_path" ]; then
        echo -e "${YELLOW}Backing up existing configuration: $target_path -> ${target_path}.backup${NC}"
        rm -rf "${target_path}.backup"
        mv "$target_path" "${target_path}.backup"
    fi

    echo -e "Linking ${GREEN}$target_path${NC} -> $source_path"
    ln -sf "$source_path" "$target_path"
}

# Sync configurations
sync_config "i3"
sync_config "polybar"
sync_config "rofi"
sync_config "dunst"
sync_config "picom"

# Sync .xprofile
XPROFILE_TARGET="$HOME/.xprofile"
if [ -f "$XPROFILE_TARGET" ]; then
    echo -e "${YELLOW}Backing up existing file: $XPROFILE_TARGET -> ${XPROFILE_TARGET}.backup${NC}"
    mv "$XPROFILE_TARGET" "${XPROFILE_TARGET}.backup"
fi
echo -e "Linking ${GREEN}$XPROFILE_TARGET${NC} -> $DOTFILES_DIR/.xprofile"
ln -sf "$DOTFILES_DIR/.xprofile" "$XPROFILE_TARGET"

# 4. Make scripts executable
echo -e "\n${BLUE}[3/4] Granting execution permissions to scripts...${NC}"
chmod +x "$DOTFILES_DIR/.config/polybar/launch.sh"
find "$DOTFILES_DIR/.config/i3/scripts" -type f -name "*.sh" -exec chmod +x {} \;
echo -e "${GREEN}Scripts are now executable.${NC}"

# 5. Finish
echo -e "\n${BLUE}[4/4] Installation Complete!${NC}"
echo -e "${GREEN}Glassmorphic Nord theme applied by default.${NC}"
echo -e "Please log out of your session and select 'i3' at your display manager login screen."
echo -e "\n${YELLOW}Important fonts note:${NC}"
echo -e "For icons to display correctly in Polybar/Rofi, please install a Nerd Font (e.g. JetBrainsMono Nerd Font)."
echo -e "You can download it from: https://www.nerdfonts.com/"
echo -e "Extract it to ~/.local/share/fonts/ and run: fc-cache -fv"
echo -e "\nJapanese Input Setup: Fcitx5 is configured to autostart. Ensure Mozc is selected in fcitx5-configtool."
echo -e "${BLUE}==================================================${NC}"
