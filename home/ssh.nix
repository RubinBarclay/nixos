{ lib, ... }:
{
  # Plain ssh-agent by default (every host wants working ssh regardless of
  # GUI). home/keepassxc.nix overrides this to false on desktop hosts, where
  # KeePassXC's own SSH Agent feature takes over the same SSH_AUTH_SOCK role.
  services.ssh-agent.enable = lib.mkDefault true;

  # Upstream only sets WantedBy=default.target, so on a cold boot ssh-agent
  # starts in parallel with mango/keepassxc rather than strictly before them
  # -- warm rebuilds-while-logged-in mask this, but a real reboot can let
  # KeePassXC's autostart check for an agent before the socket exists, and
  # KeePassXC only checks once (no retry). graphical-session-pre.target
  # exists precisely for "must finish before the graphical session starts"
  # services, and mango-session.target already waits on it, so gate it here
  # instead of racing default.target.
  systemd.user.services.ssh-agent = {
    Unit.Before = [ "graphical-session-pre.target" ];
    Install.WantedBy = [ "graphical-session-pre.target" ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/github_ed25519";
      };
    };
  };
}
