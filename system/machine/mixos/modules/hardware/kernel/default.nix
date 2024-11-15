{
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  #boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.kernelParams = [
    "drm_kms_helper.poll=0"
    "delayacct"

    #"preempt=full"
    #"mitigations=off"
    #"initcall_blacklist=acpi_cpufreq_init"

    #    "quiet"
    #    "loglevel=-1"
    #    "udev.log_level=0"
    #    "loglevel=3"
  ];
}
