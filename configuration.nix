{
  imports = [
    ./hardware-configuration.nix

    ./boot.nix
    ./networking.nix
    ./desktop.nix
    ./users.nix
    ./programs.nix

    ./services/syncthing.nix
  ];

  system.stateVersion = "26.05";
}
