{ config, pkgs, ... }:

{
  imports = [
    ./modules/system.nix
    ./modules/gaming.nix
  ];
}
