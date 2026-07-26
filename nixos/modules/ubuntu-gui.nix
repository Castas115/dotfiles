{ pkgs, lib, ... }:

# GUI packages wrapped with nixGLIntel so they find host (Ubuntu) Mesa
# drivers instead of looking for /run/opengl-driver. Only imported by
# homeConfigurations.ubuntu — NixOS hosts skip this module.

let
  nixGL = pkgs.nixgl.nixGLIntel;

  # Wrap a package so its main binary runs under nixGL.
  # `binName` defaults to pname.
  wrapGL = pkg: binName:
    let
      name = if binName == null then pkg.pname else binName;
    in
    pkgs.symlinkJoin {
      name = "${pkg.name}-nixgl";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm -f $out/bin/${name}
        makeWrapper ${nixGL}/bin/nixGLIntel $out/bin/${name} \
          --add-flags ${pkg}/bin/${name}
      '';
    };

  wrap = pkg: wrapGL pkg null;
in
{
  home.packages = [
    nixGL
    # hiPrio so wrappers win over the plain pkgs already pulled in by
    # terminal.nix / dev.nix on the ubuntu host.
    (lib.hiPrio (wrap pkgs.ghostty))
    (lib.hiPrio (wrap pkgs.alacritty))
    (lib.hiPrio (wrap pkgs.kitty))
    (wrap pkgs.wofi)
    (wrap pkgs.copyq)
    (wrap pkgs.keepassxc)
    (wrap pkgs.vlc)
    (wrapGL pkgs.swaynotificationcenter "swaync")
    pkgs.hyprshot
    pkgs.waybar
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.kanshi
    pkgs.wl-clipboard
    pkgs.wl-kbptr
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.grim
    pkgs.slurp
    pkgs.tesseract
    pkgs.libnotify
    pkgs.nwg-look
    pkgs.bibata-cursors

    pkgs.nerd-fonts.jetbrains-mono

    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
    pkgs.noto-fonts-cjk-sans
  ];

  fonts.fontconfig.enable = true;
}
