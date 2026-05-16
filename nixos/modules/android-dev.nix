{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-studio
    jdk17
  ];

  users.users.jon.extraGroups = [ "adbusers" "kvm" ];

  programs.adb.enable = true;

  # Android SDK ships generic glibc binaries (aapt2, emulator/qemu, etc.) —
  # nix-ld patches the dynamic linker at runtime so they can execute on NixOS.
  # The base set lives in system.nix; this list is merged with it.
  programs.nix-ld.libraries = with pkgs; [
    libpulseaudio
    alsa-lib
    dbus
    gperftools
    libbsd
    libdrm
    expat
    libpng
    xorg.libxcb
    xorg.libxkbfile
    xorg.libICE
    xorg.libSM
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
    mesa
    libusb1
    libuuid
  ];
}
