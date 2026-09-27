{
  programs.foot.enable = true;
  programs.btop.enable = true;

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
