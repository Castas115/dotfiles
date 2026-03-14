{ lib, ... }:

{
  # Replace with output of nixos-generate-config on the Pi
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
}
