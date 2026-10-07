####################################################################
# Template for a NixOS-WSL host — NOT wired to a real machine yet.
#
# To turn this into a real WSL2 distro:
#   1. Copy this directory to hosts/<machine-name>/ (or keep this name).
#   2. Rename the "wsl-template" attribute in flake.nix's
#      nixosConfigurations to match.
#   3. Follow NixOS-WSL's own docs (github:nix-community/NixOS-WSL) to
#      build and import this flake's output as your WSL distro.
#
# Untested from this sandbox — no `nix` binary here and no WSL2 to build
# against. Double-check against NixOS-WSL's current README before relying
# on it.
####################################################################
{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../../profiles/common.nix
    ../../services/llama-swap.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "rustikk";
  };

  networking.hostName = "wslToasterRTX";
}
