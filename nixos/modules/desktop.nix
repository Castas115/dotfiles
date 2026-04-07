{ config, pkgs, ... }:

{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd.kernelModules = [ "evdi" ];
  };

  # Display
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;
  services.displayManager.defaultSession = "hyprland";

  services.xserver.xkb = {
    layout = "us,es";
    options = "caps:none,grp:caps_toggle";
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jon";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Programs
  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  # XDG portal — explicitly route the Settings interface to gtk backend
  # so Chromium/Electron apps can detect dark mode on Hyprland.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };
  services.printing.enable = true;
  services.flatpak.enable = true;
  hardware.keyboard.zsa.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
    kanata
    hyprland
    appimage-run
  ];

  systemd.services.kanata = {
    description = "Kanata keyboard remapper";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg /home/jon/.config/kanata/kanata.kbd";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # Home-manager GUI packages
  home-manager.users.jon.home.packages = with pkgs; [
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
    libsecret
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
    wl-clipboard
    dbeaver-bin
    popsicle
	libnotify
    # warpd
	wl-kbptr
  ];
}
