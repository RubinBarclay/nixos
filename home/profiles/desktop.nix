{ ... }:
{
  imports = [
    ../stylix-desktop.nix
    ../noctalia.nix
    ../mango.nix
    # ../waybar.nix  # not wired up — see home/waybar.nix
    ../packages-desktop.nix
    ../programs-desktop.nix
  ];

  home.sessionVariables = {
    TERMINAL = "foot";
    BROWSER = "firefox";
  };
}
