{
  description = "thinkToasterT430 NixOS + mango";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    nixvim.url = "github:nix-community/nixvim";

    nixvim-config.url = "github:RubinBarclay/nixvim-config";

    stylix = {
      # Pinned to the release branch matching our nixpkgs/home-manager train
      # (release-26.05 tracks nixos-26.05 upstream) instead of Stylix's
      # unstable default branch, so its release checks don't flag a mismatch.
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      mango,
      # catppuccin,
      nixvim,
      ...
    }@inputs:
    {
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
            # foot/btop just became home-manager-managed, and stylix/noctalia have
            # both written directly into some of these config paths in the past
            # (gtk.css, starship.toml, yazi/theme.toml). Auto-rename any real file
            # activation collides with instead of hard-failing the switch.
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              # catppuccin.homeModules.catppuccin
              nixvim.homeModules.nixvim
              mango.hmModules.mango
            ];
            home-manager.users.rustikk = import ./home;
          }
        ];
      };
    };
}
