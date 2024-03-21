{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.android-nixpkgs.hmModule
  ];
  #inherit config lib pkgs;
  android-sdk = {
    enable = false;

    # Optional; default path is "~/.local/share/android".
    path = "${config.home.homeDirectory}/.android/sdk";
    #path = "/home/aj01/.android/sdk";

    packages = sdk:
      with sdk; [
        build-tools-34-0-0
        cmdline-tools-latest
        emulator
        platforms-android-34
        sources-android-34
      ];
  };
}
