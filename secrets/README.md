# Secrets (agenix)

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) so the
ciphertext can live in this git repo safely — only the decrypted plaintext
must never be committed. `.gitignore` at the repo root is already set up to
allow `secrets/*.nix`, `secrets/*.age`, and this README, and to block
everything else under `secrets/`.

## One-time setup

1. Any existing SSH keypair works — agenix reads SSH public keys directly,
   no separate age keypair needed. `~/.ssh/id_ed25519.pub` is fine.
2. Get each host's SSH host key (run on that host, as root):
   ```
   cat /etc/ssh/ssh_host_ed25519_key.pub
   ```
3. Replace every `REPLACE_ME` in `secrets.nix` with the real public keys.

## Adding a secret

From inside this `secrets/` directory:

```
agenix -e my-secret.age
```

This opens `$EDITOR` on the decrypted contents and re-encrypts on save to
every public key listed for that filename in `secrets.nix`. Commit the
resulting `.age` file as normal — it's ciphertext.

## Using a secret in a host or profile module

```nix
age.secrets.my-secret.file = ../secrets/my-secret.age;
# then reference config.age.secrets.my-secret.path at runtime wherever a
# path to the decrypted file is needed
```

## Distributing your SSH key

To get your existing GitHub SSH private key onto every host declaratively
instead of copying it over by hand each time:

1. Complete the one-time setup above (real keys in `secrets.nix`).
2. Uncomment the `"github-ssh-key.age".publicKeys = ...` line in
   `secrets.nix`.
3. From inside this directory: `agenix -e github-ssh-key.age`, paste in your
   existing private key contents (e.g. `cat ~/.ssh/github_ed25519`), save.
4. Uncomment the `age.secrets.github-ssh-key` block in `profiles/common.nix`.
5. `rebuild` — the key lands at `~/.ssh/github_ed25519` with `0600`
   permissions, owned by `rustikk`, on every host that imports
   `profiles/common.nix`.

The key's own passphrase (if it has one) still has to be typed once into
whatever's acting as your SSH agent — this only handles getting the
encrypted bytes onto disk safely, not remembering the passphrase for you.
On desktop hosts, KeePassXC (`home/keepassxc.nix`) is that agent; see its
comments for how that's wired.

## Rotating keys

After adding/removing a key in `secrets.nix` (new host, lost laptop, etc.),
re-encrypt every existing secret against the new key list:

```
agenix -r
```
