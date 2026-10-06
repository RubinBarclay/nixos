# Run agenix commands from inside this directory (see README.md).
let
  # Your own key — lets you decrypt/edit secrets from any machine holding
  # this private key. Reused from the existing github_ed25519 keypair
  # rather than a separate id_ed25519 — one key, two purposes (GitHub auth
  # + agenix decryption).
  rustikk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6a44StkzPN24PFOucfc0TCMwTzJftzdNLIrW2qo+Fq";

  # Host keys — each host that needs to decrypt a secret at activation time
  # must be listed. Get one with (run ON that host, as root):
  #   cat /etc/ssh/ssh_host_ed25519_key.pub
  thinkToasterT430 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRirCQwTsmnFNePa3Xqde4UgdZZ9BShhuEZ3MCQ5G7u root@thinkToasterT430";
  wslToasterRTX = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl45vmfGL3AuAELzBpEaTmXDO6dy/a1ibnL2RQ7zGtx root@wslToasterRTX";

  allUsers = [ rustikk ];
  allHosts = [
    thinkToasterT430
    wslToasterRTX
  ];
in
{
  "github-ssh-key.age".publicKeys = allUsers ++ allHosts;
}
