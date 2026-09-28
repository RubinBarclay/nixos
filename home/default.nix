{ ... }:
{
  # thinkToasterT430's full profile: CLI baseline + the Wayland desktop bits.
  # A CLI-only host (WSL, a server) points home-manager.users.rustikk at
  # ./profiles/common.nix directly instead of this file.
  imports = [
    ./profiles/common.nix
    ./profiles/desktop.nix
  ];
}
