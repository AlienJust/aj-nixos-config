{
  config,
  inputs,
  #pkgs,
  #platform ? null,
  platform,
  ...
}: {
  nix = {
    gc = {
      automatic = !config.programs.nh.enable;
      options = "--delete-older-than 14d";
    };
  };
  #environment.systemPackages = [inputs.nix-sweep.packages.${pkgs.system}.default];
  environment.systemPackages = [inputs.nix-sweep.packages.${platform}.default];
  #environment.systemPackages = [inputs.nix-sweep];
}
