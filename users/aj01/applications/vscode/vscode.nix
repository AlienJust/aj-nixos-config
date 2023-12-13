{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;

    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        # needed for rust lang server and rust-analyzer extension
        rustup
        zlib
        openssl.dev
        pkg-config
        # for dotnet
        dotnet-sdk_8
      ]);
    extensions = with pkgs.vscode-extensions;
      [
        mvllow.rose-pine
        eamodio.gitlens
        pkief.material-product-icons
        pkief.material-icon-theme
        jnoortheen.nix-ide
        ms-dotnettools.csharp
        # pflannery.vscode-versionlens
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "csdevkit";
          publisher = "ms-dotnettools";
          version = "1.0.12";
          sha256 = "756a724277acb4babe8060240c332612a57cded9523cfca666865255ae561f05";
          sourceRoot = ".";
        }
      ];
    userSettings = {
      #"editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      #"editor.fontFamily" = "'Iosevka Nerd Font', 'Noto Color Emoji', 'monospace', monospace";
      "editor.wordWrap" = true;
      #"workbench.colorTheme" = "Rosé Pine Moon";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";
      "workbench.productIconTheme" = "material-product-icons";
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "window.titleBarStyle" = "custom";
      #"window.zoomLevel" = -1;
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

      "omnisharp.enableAsyncCompletion" = true;
      "omnisharp.enableLspDriver" = true;
      "omnisharp.organizeImportsOnFormat" = true;
      "csharp.inlayHints.enableInlayHintsForImplicitVariableTypes" = true;
      "csharp.inlayHints.enableInlayHintsForImplicitObjectCreation" = true;
      "csharp.inlayHints.enableInlayHintsForLambdaParameterTypes" = true;
      "csharp.inlayHints.enableInlayHintsForTypes" = true;
      "dotnet.inlayHints.enableInlayHintsForIndexerParameters" = true;
      "dotnet.inlayHints.enableInlayHintsForLiteralParameters" = true;
      "dotnet.inlayHints.enableInlayHintsForObjectCreationParameters" = true;
      "dotnet.inlayHints.enableInlayHintsForOtherParameters" = true;
      "dotnet.inlayHints.enableInlayHintsForParameters" = true;
    };
  };
}
