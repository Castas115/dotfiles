# BlueZ Upgrade Needed

## Problem

BlueZ 5.80 (current stable) has a bug ([BlueZ #752](https://github.com/bluez/bluez/issues/752)) where BLE HID keyboards fail to reconnect after deep sleep. Fixed in BlueZ 5.82.

## Why we can't upgrade yet

Overlaying `bluez` from `nixpkgs-unstable` causes a rebuild cascade (pipewire, networkmanager, gtk4, libreoffice, etc.) because bluez's dependencies have different hashes in unstable. This rebuilds 200+ packages from source.

## TODO when upgrading to nixos-26.05

1. Verify `bluetoothctl --version` shows >= 5.82
2. If so, delete this file
3. If not, add the overlay:

```nix
# In flake.nix inputs:
nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

# In flake.nix outputs args:
nixpkgs-unstable

# In mkHost modules:
({ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      bluez = (import nixpkgs-unstable { inherit system; }).bluez;
    })
  ];
})
```
