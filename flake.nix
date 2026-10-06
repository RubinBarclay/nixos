{
  description = "Rubin's NixOS configs — thinkToasterT430, plus templates for future hosts";

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A NixOS system that runs *as* a WSL2 distro — see hosts/wsl-template.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning. Not wired into any host yet, but this
    # (paired with nixos-anywhere, run separately — see README) is how a
    # future server/desktop should be installed from scratch instead of by
    # hand with parted/mkfs. See hosts/server-template.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # One place that wires a host's system modules to its home-manager
      # profile, so hosts/*/default.nix only has to say what makes THAT
      # machine different, not repeat the home-manager plumbing.
      mkHost =
        {
          hostPath,
          homeProfile,
          # Extra home-manager modules the chosen homeProfile actually uses.
          # nixvim is needed everywhere (home/profiles/common.nix always
          # imports it); mango's hm module is desktop-only, so hosts that
          # don't run mango shouldn't pull it in.
          homeSharedModules ? [ inputs.nixvim.homeModules.nixvim ],
          # Extra NixOS modules a specific host needs (e.g. mango's own
          # nixosModule + enabling it) that don't belong in a shared profile.
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            hostPath

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              # stylix/noctalia have both written directly into some of
              # these config paths in the past (gtk.css, starship.toml,
              # yazi/theme.toml). Auto-rename any real file activation
              # collides with instead of hard-failing the switch.
              home-manager.backupFileExtension = "backup";
              home-manager.sharedModules = homeSharedModules;
              home-manager.users.rustikk = import homeProfile;
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        thinkToasterT430 = mkHost {
          hostPath = ./hosts/thinkToasterT430;
          homeProfile = ./home; # full profile: CLI baseline + desktop
          homeSharedModules = [
            inputs.nixvim.homeModules.nixvim
            inputs.mango.hmModules.mango
          ];
          extraModules = [
            inputs.mango.nixosModules.mango
            { programs.mango.enable = true; }
          ];
        };

        # Real, running WSL2 host (RTX 3080 passthrough, CUDA llama-swap) —
        # see hosts/wslToasterRTX/default.nix. hosts/wsl-template/ is the
        # still-untested scaffold this was copied from.
        wslToasterRTX = mkHost {
          hostPath = ./hosts/wslToasterRTX;
          homeProfile = ./home/profiles/common.nix; # CLI-only, no mango
        };

        # Untested scaffold for a future headless box — see
        # hosts/server-template/default.nix and the README.
        server-template = mkHost {
          hostPath = ./hosts/server-template;
          homeProfile = ./home/profiles/common.nix; # CLI-only, no mango
        };
      };
    };
}
