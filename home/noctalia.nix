{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        contact_shadow = false;
        shadow = false;

        default = {
          background_opacity = 0.75;
          center = [ "workspaces" ];
          end = [
            "volume"
            "brightness"
            "bluetooth"
            "network"
            "battery"
            "session"
          ];
          margin_edge = 6;
          margin_ends = 6;
          start = [
            "launcher"
            "clock"
            "control-center"
            "wallpaper"
            "clipboard"
            "notifications"
            "tray"
          ];
          thickness = 36;
        };
      };

      dock = {
        shadow = false;
      };

      lockscreen_widgets.enabled = false;

      shell = {
        font_family = "JetBrainsMono Nerd Font";
        lang = "en";
        launch_apps_as_systemd_services = true;
        telemetry_enabled = true;

        panel = {
          control_center_placement = "floating";
          open_near_click_control_center = true;
          open_near_click_session = true;
          session_placement = "floating";
          shadow = false;
        };
      };

      theme = {
        builtin = "Rosé Pine";
        mode = "dark";
        source = "builtin";

        templates = {
          enable_builtin_templates = true;

          builtin_ids = [
            "btop"
            "foot"
            "gtk3"
            "gtk4"
            "mango"
            "qt"
            "starship"
          ];
        };
      };

      wallpaper = {
        enabled = true;
        transition = [ ];

        default = {
          path = "~/Pictures/rose-pine-forrest-sun.jpg";
        };
      };
    };
  };
}
