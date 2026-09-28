{ pkgs, ... }:
{
  # foot is desktop-only (Wayland terminal) — see home/programs-desktop.nix
  programs.btop.enable = true;

  # Unfree (prebuilt binary) — allowed via nixpkgs.config.allowUnfreePredicate
  # in profiles/common.nix. That line has to live there, not here:
  # home-manager.useGlobalPkgs = true (flake.nix) means home-manager reuses
  # the system's pkgs as-is, so home-manager's own nixpkgs.config is ignored.
  home.packages = [ pkgs.claude-code ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --hidden -l ''";
    tmux.enableShellIntegration = false;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
