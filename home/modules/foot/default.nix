{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.foot;
in {
  options = {
    module.foot.enable = mkEnableOption "Enables Foot";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;

      settings = {
        scrollback = {
          lines = 65535;
        };

        main = {
          term = "xterm-256color";
          workers = 32;
          initial-window-size-chars = "115x24";
          pad = "0x4";
        };

        mouse = {
          hide-when-typing = "no";
        };

        # Swap shift+ctrl+c with ctrl+c (and vise versa) and shift+ctrl+v with ctrl+v
        /*
        key-bindings = {
          clipboard-copy = "Control+c XF86Copy";
          clipboard-paste = "Control+v XF86Paste";
        };

        text-bindings = {
          "\\x03" = "Control+Shift+c Control+Shift+C";
        };
        */
      };
    };
  };
}
