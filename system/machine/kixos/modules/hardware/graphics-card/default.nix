{pkgs, ...}: {
  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  boot.initrd.kernelModules = ["amdgpu"];

  #boot.kernelParams = [
  #  "video=HDMI-A-1:1920x1080@60"
  #  "video=DP-1:2560x1440@165"
  #];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      #rocmPackages.clr
      libva
      libva-utils
      vdpauinfo
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  #systemd.tmpfiles.rules = [
  #  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #];

  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  environment.systemPackages = with pkgs; [lact];
  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
}
