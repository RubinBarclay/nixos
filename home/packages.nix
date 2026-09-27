{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # foot and btop are managed declaratively via programs.foot/programs.btop
    # (home/programs.nix) instead, so Stylix can theme them.
    eza
    ripgrep
    fd
    bat
    fzf
    wget
    unzip

    # audio
    pamixer
    wiremix

    # wayland
    wl-clipboard
    # fuzzel

    # screenshots
    # grim
    # slurp
    # swappy

    # wallpaper
    # swaybg

    # lock screen
    # swayidle

    # browser
    firefox

    # bluetooth
    # blueman

    # networking
    wireshark
    nmap
    tcpdump
    traceroute
  ];
}
