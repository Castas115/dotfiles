{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    wiremix.url = "github:tsowell/wiremix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, claude-code-nix, wiremix, nixos-hardware, nixos-generators, ... }:
    let
      mkHost = { hostname, system, nixosModules ? [], homeModules ? [] }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}/hardware-configuration.nix
          ./hosts/${hostname}/configuration.nix
          ./modules/system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jon = {
                imports = homeModules;
                home.username = "jon";
                home.homeDirectory = "/home/jon";
                programs.git.enable = true;
                home.stateVersion = "25.05";
              };
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit claude-code-nix wiremix; };
            };
          }
        ] ++ nixosModules;
      };
    in {
      nixosConfigurations.work = mkHost {
        hostname = "work";
        system = "x86_64-linux";
        nixosModules = [ ./modules/desktop.nix ./modules/gaming.nix ];
        homeModules = [ ./modules/terminal.nix ./modules/dev.nix ];
      };

      nixosConfigurations.surf = mkHost {
        hostname = "surf";
        system = "x86_64-linux";
        nixosModules = [ ./modules/desktop.nix ./modules/gaming.nix ];
        homeModules = [ ./modules/terminal.nix ./modules/dev.nix ];
      };

      nixosConfigurations.raspi = mkHost {
        hostname = "raspi";
        system = "aarch64-linux";
        nixosModules = [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
        homeModules = [ ./modules/terminal.nix ];
      };

      packages.aarch64-linux.sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          ./hosts/raspi/configuration.nix
          ./modules/system.nix
          nixos-hardware.nixosModules.raspberry-pi-4
          home-manager.nixosModules.home-manager
          {
            users.users.jon.initialPassword = "changeme";
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jon = {
                imports = [ ./modules/terminal.nix ];
                home.username = "jon";
                home.homeDirectory = "/home/jon";
                programs.git.enable = true;
                home.stateVersion = "25.05";
              };
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit claude-code-nix wiremix; };
            };
          }
        ];
      };
    };
}
