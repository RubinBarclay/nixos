{ ... }:
{
  imports = [
    ../stylix-desktop.nix
    ../noctalia.nix
    ../mango.nix
    ../keepassxc.nix
    ../packages-desktop.nix
    ../programs-desktop.nix
  ];

  home.sessionVariables = {
    TERMINAL = "foot";
    BROWSER = "firefox";
  };
}
