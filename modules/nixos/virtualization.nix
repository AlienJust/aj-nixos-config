{
  lib,
  pkgs,
  ...
}: {
  virtualisation = {
    vmVariant = {
      virtualisation = {
        memorySize = 8192;
        cores = 4;

        sharedDirectories = {
          home = {
            source = "$HOME";
            target = "/mnt";
          };
        };
      };

      virtualisation.qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=off"
        "-audio pa,model=hda"
      ];

      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      services.interception-tools.enable = lib.mkForce false;
    };

    libvirtd = {
      /*
      qemu.ovmf.package = pkgs.OVMFFull.override {
        secureBoot = true;
        csmSupport = false;
        httpSupport = true;
        tpmSupport = true;
        edk2 = pkgs.edk2.overrideAttrs (oldAttrs: rec {
          version = "202108";

          src = pkgs.fetchFromGitHub {
            owner = "tianocore";
            repo = "edk2";
            rev = "edk2-stable202108";
            fetchSubmodules = true;
            sha256 = "1ps244f7y43afxxw6z95xscy24f9mpp8g0mfn90rd4229f193ba2";
          };

          patches = [
            # Pull upstream fix for gcc-11 build.
            (pkgs.fetchpatch {
              name = "gcc-11-vla.patch";
              url = "https://github.com/google/brotli/commit/0a3944c8c99b8d10cc4325f721b7c273d2b41f7b.patch";
              sha256 = "10c6ibnxh4f8lrh9i498nywgva32jxy2c1zzvr9mcqgblf9d19pj";
              # Apply submodule patch to subdirectory: "a/" -> "BaseTools/Source/C/BrotliCompress/brotli/"
              stripLen = 1;
              extraPrefix = "BaseTools/Source/C/BrotliCompress/brotli/";
            })
          ];
        });
      */
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
