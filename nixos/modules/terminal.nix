{ pkgs, ... }:

{
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

  home.packages = with pkgs; [
    neovim
    tmux
    fish
    nushell
    ghostty
    kitty
    alacritty
    stow
    lazygit
    delta
    jq
    eza
    unzip
    ripgrep
    btop
    fastfetch
    lynx
    bc
    sshfs
    dig
    openvpn
    openssl
    sqlite
    inotify-tools
    bluetui
    impala
    rclone
  ];
}
