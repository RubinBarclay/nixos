{ pkgs, ... }:

{
  imports = [
    ./nixvim.nix
    ./mango.nix
    ./waybar.nix
    ./shell.nix
    ./ssh.nix
    ./git.nix
    ./programs.nix
    ./desktop.nix
    ./packages.nix
  ];

  home.username = "rustikk";
  home.homeDirectory = "/home/rustikk";

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "foot";
    BROWSER = "firefox";
    PAGER = "nvim +Man!";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  services.swaync.enable = true;
  programs.swaylock.enable = true;
}
