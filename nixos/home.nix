{ config, pkgs, claude-code-nix, wiremix, ... }:

{
  imports = [
    ./modules/desktop.nix
    ./modules/terminal.nix
    ./modules/dev.nix
  ];

  home.username = "jon";
  home.homeDirectory = "/home/jon";

  programs.git.enable = true;
  home.stateVersion = "25.05";
}
