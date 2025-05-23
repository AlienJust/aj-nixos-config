{
  pkgs,
  config,
  ...
}: {
  #boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "ehci_pci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  #boot.initrd.kernelModules = [];
  # boot.kernelModules = ["kvm-amd"];
  # boot.extraModulePackages = [];
  boot = {
    #kernelPackages = pkgs.linuxPackages_cachyos;
    kernelPackages = pkgs.linuxPackages;

    kernelModules = [
      "kvm-amd"
    ];

    consoleLogLevel = 7;

    kernelParams = [
      "loglevel=7"
      "ignore_loglevel"
      "earlyprintk"
      "debug=all"
    ];

    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [];

      systemd.enable = true;
    };
  };
}
