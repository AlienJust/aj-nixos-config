_: {
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";

    efi.canTouchEfiVariables = false;
  };
}
