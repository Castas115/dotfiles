{ pkgs, claude-code-nix, wiremix, ... }:

{
  home.packages = with pkgs; [
    # Language servers
    lua-language-server
    gopls
    delve
    rust-analyzer
    nil
    bash-language-server
    shellcheck
    shfmt
    pyright
    ruff
    phpactor
    php83Packages.php-cs-fixer
    yaml-language-server
    taplo
    marksman
    typst
    tinymist
    websocat
    actionlint
    dockerfile-language-server-nodejs
    terraform-ls
    tflint

    # Formatting
    stylua
    prettierd

    # Languages
    go
    nodejs
    python3
    python3Packages.pip
    python3Packages.scrapy
    python3Packages.weasyprint
    uv

    # Cloud & infrastructure
    awscli2
    azure-cli
    terraform
    kubectl
    k9s
    minikube
	kcat

    # Containers
    docker
    dive

    # Databases
    mariadb
    postgresql

    # Tools
    claude-code-nix.packages.${pkgs.system}.default
    wiremix.packages.${pkgs.system}.default
    pandoc
    texliveSmall
  ];
}
