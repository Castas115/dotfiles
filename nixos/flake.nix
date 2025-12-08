{
	description = "My NixOS";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		home-manager.url = "github:nix-community/home-manager/release-25.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.work = nixpkgs.lib.nixosSystem {
        inherit system;
			modules = [
				./hosts/work/configuration.nix
				./modules/general.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.jon = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};

      nixosConfigurations.surf = nixpkgs.lib.nixosSystem {
        inherit system;
			modules = [
				./hosts/surf/configuration.nix
				./modules/general.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.jon = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}
