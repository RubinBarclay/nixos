# nixos

Rubin's NixOS + home-manager flake. Structured so a new machine is mostly
"pick which profiles it needs," not "write it from scratch."

## Layout

```
flake.nix              inputs + the mkHost helper + nixosConfigurations
hosts/<name>/           host-specific: hardware-configuration.nix, hostname,
                         which profiles this particular machine uses
profiles/               reusable NixOS system profiles
  common.nix             every host: user account, ssh, zsh, agenix, nix flakes
  desktop.nix             laptops/desktops with a Wayland session (mango)
  server.nix              headless boxes: ssh hardening, firewall, fail2ban
  systemd-boot-efi.nix    bare-metal EFI boot (paired per-host, not implied
                           by desktop.nix — a server could be EFI too, or not)
home/                   home-manager, mirrors the same split
  profiles/common.nix     CLI baseline: git, shell, ssh, nixvim, stylix (terminal
                           targets only), yazi/zellij/fzf/direnv/btop
  profiles/desktop.nix     + mango, noctalia, stylix's gtk/qt/foot targets,
                           GUI-only packages
  default.nix              = common + desktop, what thinkToasterT430 uses
services/               one file per self-hosted app/service, toggled per-host
secrets/                agenix-encrypted secrets — see secrets/README.md
```

## Hosts

| Host | Status | Profile mix |
|---|---|---|
| `thinkToasterT430` | real, running | desktop + systemd-boot-efi + syncthing |
| `wslToasterRTX` | real, running | common only (CLI, no GUI) + `services/llama-swap.nix` (CUDA, RTX 3080 passthrough) |
| `wsl-template` | **scaffold, untested** | common only (CLI, no GUI) |
| `server-template` | **scaffold, untested** | common + server |

The two templates exist so adding another WSL box or a homelab server is
"copy the directory and fill in the blanks," not "design it from zero." Each
one's top comment says exactly what's missing before it'll actually build.
`wslToasterRTX` is itself a filled-in copy of `wsl-template` — the template
stays untested, the copy doesn't.

## Adding a new real host

1. Copy the closest template's directory to `hosts/<name>/`.
2. Give it a real `hardware-configuration.nix`:
   - Existing machine: run `nixos-generate-config` on it and copy the file over.
   - Brand new machine, fully declarative: use
     [disko](https://github.com/nix-community/disko) for the partition layout
     (already a flake input) together with
     [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)
     (run directly, e.g. `nix run github:nix-community/nixos-anywhere -- --flake .#<name> root@<ip>`)
     to install over SSH with no USB stick.
3. Set `networking.hostName` in `hosts/<name>/default.nix` to `<name>`.
4. Add a `<name> = mkHost { ... };` entry in `flake.nix`, matching the
   attribute name to the hostname (this is what lets `rebuild`/`rebuild-boot`/
   `rebuild-test` in `home/shell.nix` work without a `#hostname` suffix, on
   every host).
5. `sudo nixos-rebuild switch --flake .#<name>` from the new machine.

## Secrets

Handled by [agenix](https://github.com/ryantm/agenix) — see
`secrets/README.md` for setup and day-to-day use. Only the encrypted `.age`
files and `secrets/secrets.nix` are committed; plaintext never is.

## Containers / self-hosting

Nix touches containers in three distinct ways — pick whichever fits:

- **Building an OCI image from a Nix derivation** (`pkgs.dockerTools.buildLayeredImage`)
  — for something you're packaging yourself. Reproducible, minimal, no Dockerfile.
- **NixOS's own containers** (`containers.<name>`, systemd-nspawn-based, not
  Docker) — for isolating a service cheaply while sharing the host's Nix store.
- **Running someone else's prebuilt image declaratively**
  (`virtualisation.oci-containers.containers.<name>`) — the usual pick for
  self-hosted apps (Jellyfin, Immich, Vaultwarden, etc.) you don't want to
  repackage yourself. [arion](https://github.com/hercules-ci/arion) is the
  closer-to-docker-compose alternative if you want that syntax.

New self-hosted services go in `services/<name>.nix` (see
`services/syncthing.nix` for the existing pattern) and get imported by
whichever host should run them.
