{ ... }:
{
  imports = [
    ../stylix.nix
    ../nixvim.nix
    ../shell.nix
    ../ssh.nix
    ../git.nix
    ../programs.nix
    ../packages.nix
  ];

  home.username = "rustikk";
  home.homeDirectory = "/home/rustikk";

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "nvim +Man!";
  };
}
