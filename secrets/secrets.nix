# Run agenix commands from inside this directory (see README.md).
#
# Every key below is a REPLACE_ME placeholder — until you swap in real
# public keys this file defines zero secrets on purpose, so agenix has
# nothing to encrypt yet. That's expected for a fresh scaffold.
let
  # Your own key — lets you decrypt/edit secrets from any machine holding
  # this private key. Get it with: cat ~/.ssh/id_ed25519.pub
  rustikk = "ssh-ed25519 AAAAREPLACE_ME rustikk@laptop";

  # Host keys — each host that needs to decrypt a secret at activation time
  # must be listed. Get one with (run ON that host, as root):
  #   cat /etc/ssh/ssh_host_ed25519_key.pub
  thinkToasterT430 = "ssh-ed25519 AAAAREPLACE_ME root@thinkToasterT430";

  allUsers = [ rustikk ];
  allHosts = [ thinkToasterT430 ];
in
{
  # "example.age".publicKeys = allUsers ++ allHosts;
}
