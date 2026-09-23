{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    systemd.enable = true;
    launch_apps_as_systemd_services = true;

    settings = {
      bar = {
        shadow = false;
        contact_shadow = false;
      };

      dock = {
        shadow = false;
      };

      shell.panel = {
        shadow = false;
      };

      # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "~/Pictures/aesthetic.jpg";
      };
    };
  };
}
