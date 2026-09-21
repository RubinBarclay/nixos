{
  description = "thinkToasterT430 NixOS + mango";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    nixvim-config.url = "github:RubinBarclay/nixvim-config";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, mango, catppuccin, nixvim, ... }@inputs: {
    nixosConfigurations.thinkToasterT430 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        mango.nixosModules.mango
        { programs.mango.enable = true; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.rustikk = import ./home.nix;
        }
      ];
    };
  };
}
