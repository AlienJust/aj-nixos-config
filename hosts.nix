{
  nixos = {
    mixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "sway";
      theme = "nord";
    };

    wixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "sway";
      theme = "nord";
    };

    kixos = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "sway";
      theme = "nord";
    };

    rasp = {
      username = "aj01";
      platform = "aarch64-linux";
      stateVersion = "25.05";
      isWorkstation = false;
      theme = "nord";
    };

    hlbox = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };

    p8box = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "sway";
      theme = "nord";
    };

    dnsvm = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };

    dbvm = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };

    gitvm = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };

    vaultvm = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };

    vpntwvm = {
      username = "aj01";
      platform = "x86_64-linux";
      stateVersion = "24.11";
      isWorkstation = false;
      theme = "nord";
    };
  };

  darwin = {
    macbox = {
      username = "aj01";
      platform = "aarch64-darwin";
      stateVersion = 5;
      isWorkstation = true;
      theme = "nord";
    };
  };
}
