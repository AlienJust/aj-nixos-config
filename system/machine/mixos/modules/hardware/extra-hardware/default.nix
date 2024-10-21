{
  lib,
  pkgs,
  config,
  ...
}: {
  # Extra drivers settings
  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = false;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;

    firmware = with pkgs; [
      linux-firmware
    ];

    /*
      logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    */
  };
}
