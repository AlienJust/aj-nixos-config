{
  nixos = {
    mixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = true;
      wm = "sway";
    };

    kixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "sway";
    };

    wixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = true;
      wm = "sway";
    };

    hpb-nix = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
    };

    rasp = {
      username = "aj01";
      platform = "aarch64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
    };
  };

  darwin = {
    macbox = {
      username = "aj01";
      platform = "aarch64-darwin";
      stateVersion = 6;
      isWorkstation = true;
    };
  };
}
