# CLAUDE.md

Personal NixOS + home-manager flake for Rubin (`rustikk`). This file is for
whichever Claude Code session is working in this repo next — conventions,
decisions, and known-unverified pieces, so they don't get re-derived or
accidentally undone. User-facing setup steps (adding a host, secrets, etc.)
live in `README.md` and `secrets/README.md` instead — read this alongside
those, not in place of them.

## Structure

```
flake.nix               inputs + mkHost helper + nixosConfigurations
hosts/<name>/            host-specific: hardware-configuration.nix, hostname
profiles/                reusable NixOS profiles: common / desktop / server /
                          systemd-boot-efi
home/                    home-manager; profiles/common.nix + profiles/desktop.nix
                          mirror the system-side split
services/                one file per self-hosted service, opt-in per host
secrets/                 agenix — secrets.nix + *.age (encrypted, committed);
                          plaintext is never committed
```

## Hard rule: attribute name == hostname

Every `nixosConfigurations.<name>` attribute in `flake.nix` must equal that
host's `networking.hostName`. `home/shell.nix`'s `rebuild`/`rebuild-boot`/
`rebuild-test` aliases deliberately omit `--flake .#<name>` and rely on
`nixos-rebuild` auto-matching the flake attribute to the machine's real
hostname. Breaking that equality breaks those aliases on that host.

## Real host vs. scaffolds

- `hosts/thinkToasterT430/` is the one real, running machine.
- `hosts/wsl-template/` and `hosts/server-template/` are **intentionally
  untested scaffolds** — written from documentation/inference, never built
  (no `nix` binary is available in a Claude Code web/cloud session; see
  below). Don't treat them as proven. `server-template` has no
  `hardware-configuration.nix` on purpose and won't build until one is added.

## Theming: Stylix everywhere except Neovim

`home/stylix.nix` (+ `home/stylix-desktop.nix` for gtk/qt/foot) drives
base16 theming (Rosé Pine, `pkgs.base16-schemes`) across zellij, yazi, btop,
starship, foot, gtk, qt. **Neovim is the deliberate exception**:
`stylix.targets.nixvim.enable = false` — base16's 16-slot model was tested
and judged too flat for syntax highlighting, so Neovim uses nixvim-config's
own dedicated `rose-pine.nvim` colorscheme instead. Don't "fix" this by
re-enabling the stylix nixvim target; it was a considered tradeoff, not an
oversight.

`config.lib.stylix.colors.base0A` is Rosé Pine's "Rose" (`#ebbcba`) in the
tinted-theming base16 port. `base0E` is gold/orange in this scheme, **not**
purple — don't assume the conventional base16→ANSI mapping when picking a
color slot (this bit us once already, on mango's border color).

## mango keybinding scheme

Everything WM-level lives on `SUPER`/`SUPER+SHIFT` (see `home/mango.nix`).
Alt and Ctrl are deliberately left untouched for apps/zellij — the old
Alt-based binds clashed with Firefox's Alt+Left/Right. The `SUPER+SHIFT`
combined-modifier string is inferred from dwl-style config convention, not
verified against mango's own docs (its docs site isn't reachable from a
Claude Code sandbox) — if a shift-combo bind doesn't fire, check that first.

## Secrets: two separate systems, don't blur them

- **agenix** (`secrets/`) — for secrets NixOS itself consumes at
  activation/boot (service API keys, the personal SSH key deployment
  scaffold in `profiles/common.nix`, currently commented out until
  `secrets/github-ssh-key.age` actually exists).
- **KeePassXC** (`home/keepassxc.nix`, desktop-only) — for secrets a human
  recalls/types. Syncs its `.kdbx` via Syncthing (unrelated to agenix). Also
  serves as the SSH agent: it binds to `$SSH_AUTH_SOCK` directly rather than
  creating its own socket (verified against KeePassXC's own source, not its
  docs site, which is also unreachable from this sandbox) — plain
  `services.ssh-agent` is force-disabled only on desktop hosts
  (`lib.mkDefault true` elsewhere, so WSL/server hosts keep a normal agent).

Don't try to make agenix hold personal passwords, or KeePassXC hold
service-consumed secrets — they have different consumers and lifecycles.

## Companion repo

`nixvim-config` (`RubinBarclay/nixvim-config`, a separate GitHub repo and
flake input, pulled in via `inputs.nixvim-config` + `home/nixvim.nix`) is Rubin's
trimmed, close-to-vanilla Neovim config — own conventions apply there (no AI
completion, no in-editor terminal since zellij covers that, `keys.nix`
stripped to just `leader = space`, blink.cmp/yazi.nvim/rustaceanvim/
roslyn.nvim as the deliberate plugin choices). Don't edit it from inside this
repo; it's a separate clone/PR.

## Verifying changes

**No `nix` binary is available in a Claude Code web/cloud session.** Nix
syntax here has historically been checked by hand (brace/paren/bracket
balance, careful reading) rather than `nix flake check`/`nix eval`/a real
build — every change described as "verified" in this repo's history means
verified that way, then confirmed for real by Rubin running `rebuild` on
`thinkToasterT430` afterward. Always say so explicitly rather than implying
a build was actually run, and always ask for that real-machine confirmation
before treating a change as done. A local Claude Code session running
directly on `thinkToasterT430` (or a future host) *can* and should just run
`nixos-rebuild build --flake .#<host>` / `nix flake check` directly instead.
