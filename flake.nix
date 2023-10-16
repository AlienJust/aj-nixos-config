{
  description = "AJ nix config";

  inputs = {
    # Nixpkgs
    #nixpkgs.follows = "master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    #master.url = "github:nixos/nixpkgs/master";
    #stable.url = "github:nixos/nixpkgs/release-23.05";
    #unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      mixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.aj01 = import ./home-manager/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
