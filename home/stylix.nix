{ inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    # home-manager.useGlobalPkgs expects nixpkgs.overlays to only be set at the
    # system level. Stylix's per-user overlay (injected here by default) is only
    # populated by targets that ship a modules/<target>/overlay.nix — none of the
    # targets enabled below have one, so there's nothing lost by turning it off.
    # If a future target you enable needs it, add that overlay at the system
    # level (a NixOS host/profile module) instead of flipping this back on.
    overlays.enable = false;

    targets = {
      # Neovim uses nixvim-config's own dedicated rose-pine.nvim colorscheme
      # instead (see home/nixvim.nix) — base16's reduced 16-slot model caps
      # syntax highlighting quality no matter which renderer plugin draws it,
      # and the editor is worth the tradeoff of not sharing one literal palette
      # with everything else.
      nixvim.enable = false;
      zellij.enable = true;
      yazi.enable = true;
      btop.enable = true;
      starship.enable = true;
      # foot/gtk/qt are desktop-only — see home/stylix-desktop.nix
    };
  };
}
