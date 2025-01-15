_: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4da79335-1aac-4d8a-aafc-81057f25a8c1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9DB1-3947";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];
}
