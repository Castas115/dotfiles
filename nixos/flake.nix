{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    wiremix.url = "github:tsowell/wiremix";
  };

  outputs = { self, nixpkgs, home-manager, claude-code-nix, wiremix, ... }:
    let
      system = "x86_64-linux";

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}/hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jon = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit claude-code-nix wiremix; };
            };
          }
        ];
      };
    in {
      nixosConfigurations.work = mkHost "work";
      nixosConfigurations.surf = mkHost "surf";
    };
}
