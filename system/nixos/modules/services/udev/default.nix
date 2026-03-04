{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.services.udev;
in {
  options = {
    module.services.udev.enable = mkEnableOption "Enable udev";
  };

  config = mkIf cfg.enable {
    # Udev rules
    services.udev.extraRules = ''
      KERNEL=="ttyUSB[0-9]*", MODE="0666"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
    '';
  };
}
