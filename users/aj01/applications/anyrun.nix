{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages; [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.translate
      ];
      hidePluginInfo = true;
      layer = "overlay";
      closeOnClick = true;
      y.absolute = 150;
    };

    extraCss = ''
      * {
        transition: unset;
        border-radius: unset;
        font-family: 'BalsamiqSans', sans-serif;
        font-weight: normal;
        font-size: 21px;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match:selected {
        color: #232136;
        background: #5b4676;
      }

      #list {
        border-top: 3px solid #931500;
      }

      #entry {
        border: unset;
        box-shadow: unset;
      }

      #plugin {
        border: unset;
      }

      box#main {
        background: #232136;
        border: 3px solid #5b4676;
      }
    '';
  };
}
