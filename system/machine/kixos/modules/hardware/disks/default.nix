_: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=3G" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F4EB-22AC";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/94435ba3-7d58-476f-ab83-1c549cb5a8a2";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f11d0acc-7ddf-4d6d-ae5a-a946c9c5cb0c";
    fsType = "ext4";
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [];
}
