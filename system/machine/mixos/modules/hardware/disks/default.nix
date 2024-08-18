_: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=32G" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/564C-C792";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/508eb67f-e7bf-4770-9575-f9065c1f5677";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f6c9b07d-6fe8-4d0e-9eb2-ad0f35faf2d5";
    fsType = "ext4";
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [];
}
