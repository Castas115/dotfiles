{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Lua
    lua-language-server

    # Go
    gopls
    delve  # debugger

    rust-analyzer
    nil # Nix

    # Bash
    bash-language-server
    shellcheck
    shfmt

    # Python
    pyright
    ruff  # linter + formatter

    phpactor
    php83Packages.php-cs-fixer

    yaml-language-server
    taplo # TOML
    marksman # Markdown
    typst
    tinymist # Typst LSP
    websocat # for typst-preview
    actionlint  # GitHub Actions linter
    dockerfile-language-server-nodejs
    terraform-ls
    tflint  # terraform linter


    # Formatting
    stylua
    prettierd
  ];
}
