_: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=3G" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AED0-C217";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a186ace6-acc4-42d9-ba0b-056829a12d26";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f11d0acc-7ddf-4d6d-ae5a-a946c0c5cb0c";
    fsType = "ext4";
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [];
}
