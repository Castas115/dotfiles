{ ... }:

{
  boot.resumeDevice = "/dev/disk/by-uuid/8e4e0e2d-c59e-4aee-b830-5be8de4b7902";

  systemd.tmpfiles.rules = [
    "w /sys/power/image_size - - - - 0"
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';
}
