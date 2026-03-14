{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vivaldi
    chromium
    copyq
    hyprlock
    hypridle
    hyprshot
    nwg-look
    waybar
    wofi
    keepassxc
    blueberry
    kanshi
    swaynotificationcenter
    vlc
    bibata-cursors
    libreoffice
    anki
    brightnessctl
    playerctl
    remmina
    anydesk
    teams-for-linux
    wl-clipboard
    dbeaver-bin
  ];
}
