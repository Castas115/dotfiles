{ config, pkgs, claude-code-nix, ... }:

{
	home.username = "jon";
	home.homeDirectory = "/home/jon";

	programs.git.enable = true;
	home.stateVersion = "25.05";

	programs.atuin = {
		enable = true;
		enableBashIntegration = true;
		enableFishIntegration = true;
		enableNushellIntegration = true;
	};

	programs.zoxide = {
		enable = true;
		enableBashIntegration = true;
		enableFishIntegration = true;
		enableNushellIntegration = true;
	};

	programs.bash = {
		enable = true;
		shellAliases = {
			ll = "ls -alF";
			la = "ls -A";
			l  = "ls -CF";
			c  = "__zoxide_z";
			cf = "__zoxide_zi";
			v  = "nvim";
			g  = "lazygit";

		};
	};

	# home.file.".config/fish".source = ../.config/fish;

	home.packages = with pkgs; [
		neovim 
		vivaldi
		tmux
		fish
		nushell
		copyq
		zoxide
		atuin
		sshfs
		ghostty
		kitty
		stow
		lazygit
		hyprlock
		hypridle
		nwg-look
		waybar
		wofi
		delta
		keepassxc
		blueberry
		kanshi
		jq
		hyprshot
		swaynotificationcenter
		vlc
		bibata-cursors
		sqlite
		eza
		unzip
		dig
		openvpn
		openssl
		dbeaver-bin
		dive
		docker
		ripgrep
		eza
		mariadb
		nodejs
		mermaid-cli
		azure-cli
		btop
		libreoffice
		bruno
		anki
		brightnessctl
		playerctl
		inotify-tools
		claude-code-nix.packages.${pkgs.system}.default
	];

}
