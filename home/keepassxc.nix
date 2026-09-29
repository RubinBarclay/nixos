{ pkgs, ... }:
{
  # KeePassXC adds convenience on top of a real ssh-agent: unlock the vault
  # once and, for any entry with a key attached under its SSH Agent tab,
  # that key gets loaded into the agent automatically — no separate
  # `ssh-add` + typed passphrase step.
  #
  # An earlier version of this comment (written when KeePassXC's docs site
  # wasn't reachable) assumed KeePassXC implements its own agent on Linux
  # and disabled the plain agent as a result — confirmed wrong against
  # home-manager's services.ssh-agent module and a matching upstream
  # KeePassXC issue (keepassxreboot/keepassxc#8777, same "no agent
  # running" symptom): on Linux/macOS KeePassXC is agent-protocol client
  # only, it never listens on the socket itself. It requires a real
  # ssh-agent already running at $SSH_AUTH_SOCK; home/ssh.nix's
  # `services.ssh-agent.enable = lib.mkDefault true` provides that, so this
  # file no longer overrides it. $SSH_AUTH_SOCK itself is also no longer
  # set here — services.ssh-agent's own sshAuthSock.initialization already
  # exports the correct path for every shell.
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
