{pkgs, ...}: {
  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      #rocmPackages.clr.icd
      #rocmPackages.clr
      #libva
      #libva-utils
      #vdpauinfo
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  #systemd.tmpfiles.rules = [
  #  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #];
}
