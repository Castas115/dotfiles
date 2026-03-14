{ config, pkgs, ... }:

{
  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    networkmanager.dns = "none";
    dhcpcd.extraConfig = "nohook resolv.conf";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;
  services.displayManager.defaultSession = "hyprland";

  services.xserver.xkb = {
    layout = "us,es";
    options = "caps:none,grp:caps_toggle";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jon = {
    isNormalUser = true;
    description = "jon";
    extraGroups = [ "jon" "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jon";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "Jon";
      user.email = "joncastas@gmail.com";
      init.defaultBranch = "main";
    };
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      kernelModules = [ "evdi" ];
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    nerd-fonts.jetbrains-mono
    gcc
    kanata
    hyprland
    appimage-run
  ];

  virtualisation.docker.enable = true;

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

  systemd.services.gitsync = {
    description = "Auto-sync git repositories on file changes";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "jon";
      ExecStart = "${pkgs.bash}/bin/bash /home/jon/dotfiles/scripts/gitsync.sh";
      Restart = "on-failure";
      RestartSec = 10;
    };
    path = with pkgs; [ git inotify-tools bash ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

  services.flatpak.enable = true;
  hardware.keyboard.zsa.enable = true;
}
