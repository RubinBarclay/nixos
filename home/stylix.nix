{ inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    targets = {
      nixvim.enable = true;
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
