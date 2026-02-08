{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Enable hibernation (resume from swap)
  boot.resumeDevice = "/dev/disk/by-uuid/8e4e0e2d-c59e-4aee-b830-5be8de4b7902";

  # Minimal hibernation image for faster resume
  systemd.tmpfiles.rules = [
    "w /sys/power/image_size - - - - 0"
  ];

  # Suspend-then-hibernate: suspend first, hibernate after 30 min
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';
}
