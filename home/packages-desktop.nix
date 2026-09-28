{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # audio
    pamixer
    wiremix

    # wayland
    wl-clipboard

    # browser
    firefox

    # networking (GUI-capable; nmap/tcpdump/traceroute in packages.nix
    # already cover headless diagnostics)
    wireshark
  ];
}
