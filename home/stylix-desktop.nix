{ ... }:
{
  # foot/gtk/qt only matter with a real Wayland desktop session — split out
  # from home/stylix.nix so CLI-only hosts (WSL, servers) don't pull them in.
  stylix.targets = {
    foot.enable = true;
    gtk.enable = true;
    qt.enable = true;
  };
}
