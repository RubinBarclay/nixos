{ pkgs, lib, ... }:
{
  # KeePassXC replaces the plain ssh-agent as our SSH agent: unlock the vault
  # once and both password autotype/browser-fill AND SSH auth are live, no
  # separate `ssh-add` + typed passphrase step.
  #
  # How this actually works (verified against KeePassXC's own source, since
  # its docs site isn't reachable from this sandbox): on Linux, KeePassXC's
  # SSH Agent feature does NOT create its own socket path. It checks its
  # own "AuthSockOverride" setting first (left unset here) and otherwise
  # binds to whatever $SSH_AUTH_SOCK already points at when it starts. So
  # this only works if (a) nothing else is already listening on that path —
  # hence turning plain ssh-agent off below — and (b) $SSH_AUTH_SOCK is set
  # in the session *before* KeePassXC launches. Confirm after rebuilding by
  # checking `echo $SSH_AUTH_SOCK` in a terminal matches this path, and that
  # `ssh-add -l` lists your key once the vault is unlocked.
  services.ssh-agent.enable = lib.mkForce false;

  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

  programs.keepassxc = {
    enable = true;
    package = pkgs.keepassxc;

    settings = {
      Browser.Enabled = true;
      SSHAgent.Enabled = true;

      GUI = {
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
      };
    };
  };
}
