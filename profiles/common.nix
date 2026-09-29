{ inputs, lib, pkgs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    inputs.agenix.packages.${pkgs.system}.default
  ];

  # Scoped rather than a blanket `allowUnfree = true` — currently just for
  # claude-code (home/programs.nix), which ships as a prebuilt binary.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  services.openssh.enable = true;
  # Let SSH clients forward COLORTERM so truecolor-detecting apps (Claude
  # Code's custom theme creator, chalk/supports-color-based zsh coloring)
  # see the same 24-bit color support over SSH as they do locally. TERM
  # itself doesn't need this — it's negotiated via the pty allocation
  # request, not a plain env var, so it already comes through unaided.
  services.openssh.settings.AcceptEnv = [ "COLORTERM" ];

  programs.zsh.enable = true;

  users.users.rustikk = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  console.keyMap = lib.mkDefault "sv-latin1";
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  system.stateVersion = lib.mkDefault "26.05";

  # Deploy the personal SSH key (home/ssh.nix expects it at
  # ~/.ssh/github_ed25519) to every host automatically instead of copying it
  # over by hand each time. Commented out until secrets/github-ssh-key.age
  # actually exists — see secrets/README.md's "Distributing your SSH key"
  # section for the one-time setup, then uncomment this block.
  #
  # age.secrets.github-ssh-key = {
  #   file = ../secrets/github-ssh-key.age;
  #   path = "/home/rustikk/.ssh/github_ed25519";
  #   owner = "rustikk";
  #   group = "users";
  #   mode = "0600";
  # };
}
