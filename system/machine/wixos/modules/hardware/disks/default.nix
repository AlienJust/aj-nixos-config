_: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=12G" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2ff055a9-f527-4d16-a847-fdbda2b3347a";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e142e3d1-ce8d-4bad-98ad-4c5463de5907";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0B86-7DC5";
    fsType = "vfat";
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [];
}
