{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.ssh;
in {
  options = {
    module.ssh = {
      enable = mkEnableOption "Enables ssh";
    };
  };

  config = mkIf cfg.enable {
    # Virtualization settings
    services.openssh = {
      enable = true;
      # Forbid root login through SSH.
      settings.PermitRootLogin = "no";
      ## Use keys only. Remove if you want to SSH using password (not recommended)
      #passwordAuthentication = false;
    };
  };
}
