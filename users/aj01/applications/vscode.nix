{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      mvllow.rose-pine
      eamodio.gitlens
      pkief.material-product-icons
      pkief.material-icon-theme
      jnoortheen.nix-ide
      ms-dotnettools.csharp
    ];
    userSettings = {
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "'Iosevka Term', 'M PLUS 1 Code', 'Maple Mono NF', 'Noto Color Emoji', 'monospace', monospace";
      "workbench.colorTheme" = "Rosé Pine Moon";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";
      "workbench.productIconTheme" = "material-product-icons";
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = "-1";
      "[nix]" = {"editor.defaultFormatter" = "jnoortheen.nix-ide";};
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };
    };
  };
}
