{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.minecraft;
in {
  options = {
    module.mako.enable = mkEnableOption "Enables minecraft";
  };

  config = mkIf cfg.enable {
    programs.minecraft = {
      shared = {
        username = "Alex";
      };
      versions = {
        "vanilla18" = {
          minecraft.version = "1.18";
        };
        "projectozone3" = {
          modpack.curseforge = {
            projectId = 256289;
            fileId = 3590506;
            hash = "sha256-sm1JihpKd8OeW5t8E4+/wCgAnD8/HpDCLS+CvdcNmqY=";
          };
          forge.hash = "sha256-5lQKotcSIgRyb5+MZIEE1U/27rSvwy8Wmb4yCagvsbs=";
        };
      };
    };
  };
}
