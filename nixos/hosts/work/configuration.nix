{ pkgs, ... }:

{
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "mute-speaker-on-usb-eth" ''
        iface="$1"
        action="$2"
        case "$iface" in
          enp0s13f0u*) ;;
          *) exit 0 ;;
        esac
        [ "$action" = "up" ] || exit 0
        ${pkgs.util-linux}/bin/runuser -l jon -c \
          'XDG_RUNTIME_DIR=/run/user/1000 /home/jon/.config/hypr/scripts/mute-speaker.sh'
      '';
    }
  ];
}
