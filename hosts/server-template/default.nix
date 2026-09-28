####################################################################
# Template for a future headless server/homelab box — NOT wired to a real
# machine yet, and deliberately has no hardware-configuration.nix.
#
# To turn this into a real host:
#   1. Provision the machine (bare metal or VPS) and get a real
#      hardware-configuration.nix for it — either run
#      `nixos-generate-config` on it, or use nixos-anywhere + disko for a
#      fully declarative from-scratch install (see the repo README).
#   2. Copy this directory to hosts/<machine-name>/, drop that
#      hardware-configuration.nix in next to this file and add it to the
#      imports below, and set a real hostname.
#   3. Rename the "server-template" attribute in flake.nix's
#      nixosConfigurations to match.
#   4. Uncomment/add whichever services/*.nix modules this box should run.
#
# Until step 1 happens, `nixos-rebuild build/switch` will refuse this
# config — there's no fileSystems."/" defined yet, on purpose.
####################################################################
{
  imports = [
    ../../profiles/common.nix
    ../../profiles/server.nix

    # ../../services/syncthing.nix
  ];

  networking.hostName = "server-template";
}
