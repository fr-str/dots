yay -S \
    --noconfirm \
    --needed \
    hyprland \
    hyprpaper \
    power-profiles-daemon \
    otf-font-awesome \
    mako \
    wmenu \
    waybar \
    brightnessctl \
    dolphin \
    firefox \
    pipewire \
    xdg-desktop-portal-hyprland \
    hyprpolkitagent \
    qt5-wayland \
    qt6-wayland  \
    foot \
    playerctl \
    mpv
    
mkdir -p $HOME/.config/hypr/
ln -s $HOME/.dots/hyprland.conf $HOME/.config/hypr/
mkdir -p $HOME/.config/waybar
ln -s $HOME/.dots/waybar/style.css $HOME/.config/waybar/
ln -s $HOME/.dots/waybar/config.jsonc $HOME/.config/waybar/
