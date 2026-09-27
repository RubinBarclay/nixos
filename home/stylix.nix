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
    # level (configuration.nix) instead of flipping this back on.
    overlays.enable = false;

    targets = {
      nixvim = {
        enable = true;
        # mini.base16 (the default) only maps a handful of highlight groups,
        # which is why most syntax fell back to plain text. base16-nvim has
        # much fuller Treesitter/LSP semantic-token coverage for the same
        # palette.
        plugin = "base16-nvim";
      };
      zellij.enable = true;
      yazi.enable = true;
      foot.enable = true;
      btop.enable = true;
      starship.enable = true;
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
