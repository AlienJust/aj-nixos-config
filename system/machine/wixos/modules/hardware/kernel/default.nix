{
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.kernelParams = [
    "preempt=full"
    "mitigations=off"
    "initcall_blacklist=acpi_cpufreq_init"
    #    "quiet"
    #    "loglevel=-1"
    #    "udev.log_level=0"
    #    "loglevel=3"
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      #driSupport = true;
      #driSupport32Bit = true;
      extraPackages = with pkgs; [
        #        amdvlk
        #        rocm-opencl-icd
        #        rocm-opencl-runtime
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
