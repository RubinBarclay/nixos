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

## Rotating keys

After adding/removing a key in `secrets.nix` (new host, lost laptop, etc.),
re-encrypt every existing secret against the new key list:

```
agenix -r
```
