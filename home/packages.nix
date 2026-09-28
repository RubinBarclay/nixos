{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # btop is managed declaratively via programs.btop (home/programs.nix)
    # instead, so Stylix can theme it. foot/audio/browser/wireshark are
    # desktop-only — see home/packages-desktop.nix.
    eza
    ripgrep
    fd
    bat
    fzf
    wget
    unzip

    # networking diagnostics — useful headless too
    nmap
    tcpdump
    traceroute
  ];
}
