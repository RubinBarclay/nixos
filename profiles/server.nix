{ lib, ... }:
{
  # Headless box defaults. Unknown-spec target (VPS or bare metal) so this
  # deliberately avoids NetworkManager/bluetooth/a display session — plain
  # DHCP unless a host overrides it with a static config.

  networking.useDHCP = lib.mkDefault true;
  networking.firewall.enable = lib.mkDefault true;

  services.fail2ban.enable = true;

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
  };

  # Nobody's babysitting this box's disk usage by hand.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
