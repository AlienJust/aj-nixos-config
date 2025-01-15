{
  pkgs,
  config,
  ...
}: {
  boot = {
    # kernelPackages = pkgs.linuxPackages_cachyos;

    kernelModules = [];

    extraModulePackages = [];

    kernelParams = [
      "delayacct"
    ];

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "ohci_pci"
        "ehci_pci"
        "ahci"
        "sd_mod"
        "sr_mod"
      ];

      kernelModules = [];
    };
  };
}
