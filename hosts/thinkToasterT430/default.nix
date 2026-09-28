{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/common.nix
    ../../profiles/desktop.nix
    ../../profiles/systemd-boot-efi.nix

    ../../services/syncthing.nix
  ];

  networking.hostName = "thinkToasterT430";
}
