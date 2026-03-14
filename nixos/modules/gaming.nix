{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;
}
