{ lib, ... }:
{
  # Plain ssh-agent by default (every host wants working ssh regardless of
  # GUI). home/keepassxc.nix overrides this to false on desktop hosts, where
  # KeePassXC's own SSH Agent feature takes over the same SSH_AUTH_SOCK role.
  services.ssh-agent.enable = lib.mkDefault true;

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
