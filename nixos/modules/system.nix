{ config, pkgs, ... }:

{
  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    networkmanager.dns = "none";
    dhcpcd.extraConfig = "nohook resolv.conf";
  };

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

  users.users.jon = {
    isNormalUser = true;
    description = "jon";
    extraGroups = [ "jon" "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Jon";
      user.email = "joncastas@gmail.com";
      init.defaultBranch = "main";
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
    gcc
	zstd
  ];

  virtualisation.docker.enable = true;

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
}
