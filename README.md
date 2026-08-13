# i3 Dotfiles for OpenSUSE — Nord Glassmorphic

A minimalist, premium-looking **i3** Window Manager configuration for **OpenSUSE Tumbleweed/Leap**, designed around the **Nord** color palette with a modern **glassmorphic aesthetic** — translucent windows, dual-kawase blur, rounded corners, and clean typography.

##  Features

*   **Nord Theme**: A single, carefully crafted color scheme derived from the Arctic Nord palette (`#2e3440` series), applied consistently across i3, Polybar, Rofi, and Dunst.
*   **Glassmorphism**: Real background blur via Picom's `dual_kawase` method with translucent window and bar backgrounds — no fake opacity tricks.
*   **Modular Component Layout**: Clean file structure under `~/.config/`.
*   **Aesthetic Status Bar**: Minimal Polybar layout using semi-transparent Nord colors. Workspaces, CPU, RAM, Wi-Fi, battery, and power menu.
*   **Beautiful Notifications**: Dunst notifications styled with a frosted-glass Nord backdrop and rounded corners.
*   **Icon Theme**: Uses **Papirus** icons for a sharp, flat aesthetic.
*   **Japanese Input Support**: Fcitx5 + Mozc configured out-of-the-box.

---

##  Quick Start & Installation

```bash
git clone https://github.com/shunature/i3-dotfiles.git
cd i3-dotfiles
chmod +x install.sh
./install.sh
```

### Dependency List (Managed by `install.sh`)

*   **Window Manager**: `i3` (with native gaps support)
*   **Compositor**: `picom` (GLX backend, dual_kawase blur, rounded corners)
*   **Status Bar**: `polybar`
*   **Launcher**: `rofi` (styled with **Papirus** icons)
*   **Notifications**: `dunst`
*   **Icon Theme**: `papirus-icon-theme`
*   **Japanese Input**: `fcitx5`, `fcitx5-mozc`, `fcitx5-gtk`, `fcitx5-qt`, `fcitx5-configtool`
*   **Utilities**: `kitty` (terminal), `feh` (wallpaper), `maim` & `xclip` (screenshots), `pamixer`, `brightnessctl`, `playerctl`

> [!IMPORTANT]
> **Required Fonts**: Please install a **Nerd Font** (e.g., JetBrainsMono Nerd Font) for icons to display correctly in Polybar and Rofi.
> Download from [Nerd Fonts](https://www.nerdfonts.com/), extract to `~/.local/share/fonts/` and run `fc-cache -fv`.

---

##  Core Keybindings

| Keybinding | Action |
| :--- | :--- |
| `Super` + `Return` | Launch Terminal (`kitty`) |
| `Super` + `d` | Application Launcher (`rofi`) |
| `Super` + `q` | Kill current window |
| `Super` + `Escape` | **Power/Session Menu** |
| `PrintScreen` | Take Full Screenshot |
| `Shift` + `PrintScreen` | Take Selected Area Screenshot |
| `Super` + `r` | Resize Mode |
| `Super` + `Shift` + `r` | Restart i3 in-place |

### System Controls (Hardware Keys)
*   **Volume Up/Down/Mute**: `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` / `XF86AudioMute`
*   **Brightness Up/Down**: `XF86MonBrightnessUp` / `XF86MonBrightnessDown`
*   **Media Controls**: `XF86AudioPlay` / `XF86AudioNext` / `XF86AudioPrev`

---

## 日本語入力 (Fcitx5 + Mozc)

1.  `~/.xprofile` に以下の環境変数が設定されます:
    ```bash
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    ```
2.  `fcitx5` デーモンはi3セッション起動時に自動起動します。
3.  `fcitx5-configtool` を実行して「Mozc」が入力メソッドに追加されていることを確認してください。

---

## 🦾 Created With

This configuration repository was generated and styled with the help of **Antigravity**, an agentic AI coding assistant developed by Google DeepMind.
