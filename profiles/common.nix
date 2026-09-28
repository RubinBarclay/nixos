{ inputs, lib, pkgs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    inputs.agenix.packages.${pkgs.system}.default
  ];

  services.openssh.enable = true;

  programs.zsh.enable = true;

  users.users.rustikk = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  console.keyMap = lib.mkDefault "sv-latin1";
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  system.stateVersion = lib.mkDefault "26.05";
}
