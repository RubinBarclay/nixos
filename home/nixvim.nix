{ inputs, ... }:

{
  programs.nixvim = {
    enable = true;

    imports = [ inputs.nixvim-config.nixvimModule ];

    # nixvim-config's own rose-pine.nvim colorscheme (mkDefault true) is left
    # as-is — stylix.targets.nixvim is disabled (home/stylix.nix) so there's
    # no longer anything fighting it for the `:colorscheme` call.
  };
}
