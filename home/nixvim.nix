{ inputs, lib, ... }:

{
  programs.nixvim = {
    enable = true;

    imports = [ inputs.nixvim-config.nixvimModule ];

    # Stylix (home/stylix.nix) drives the colorscheme now — the fork's own
    # rose-pine default would otherwise fight it for the last `:colorscheme` call.
    colorschemes.rose-pine.enable = lib.mkForce false;
  };
}
