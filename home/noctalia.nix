{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

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
      # lockscreen_widgets = {
      #   enabled = false;
      #   schema_version = 2;
      #   widget_order = [ "lockscreen-login-box@LVDS-1" ];
      #
      #   grid = {
      #     cell_size = 16;
      #     major_interval = 4;
      #     visible = true;
      #   };
      #
      #   widget."lockscreen-login-box@LVDS-1" = {
      #     box_height = 196.0;
      #     box_width = 810.0;
      #     cx = 800.0;
      #     cy = 718.0;
      #     output = "LVDS-1";
      #     placement_height = 900.0;
      #     placement_width = 1600.0;
      #     rotation = 0.0;
      #     type = "login_box";
      #
      #     settings = {
      #       background_color = "surface_variant";
      #       background_opacity = 0.88;
      #       background_radius = 12.0;
      #       center_password_text = false;
      #       input_opacity = 1.0;
      #       input_radius = 6.0;
      #       layout = "regular";
      #       show_caps_lock = true;
      #       show_keyboard_layout = true;
      #       show_login_button = true;
      #       show_media = true;
      #       show_session_buttons = true;
      #       show_unlock_hint = true;
      #       show_weather = true;
      #     };
      #   };
      # };

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
          ];
        };
      };

      wallpaper = {
        enabled = true;
        transition = [ ];

        default = {
          path = "~/Pictures/cameras.png";
        };
      };
    };

  };
  #########################################################
  # programs.noctalia-old = {
  #   enable = true;
  #
  #   systemd.enable = true;
  #
  #   settings = {
  #     bar = {
  #       shadow = false;
  #       contact_shadow = false;
  #     };
  #
  #     dock = {
  #       shadow = false;
  #     };
  #
  #     shell = {
  #       launch_apps_as_systemd_services = true;
  #       panel = {
  #         shadow = false;
  #       };
  #     };
  #
  #     # This may also be a string or path to a .toml file.
  #     theme = {
  #       mode = "dark";
  #       source = "builtin";
  #       builtin = "Catppuccin";
  #     };
  #
  #     wallpaper = {
  #       enabled = true;
  #       default.path = "~/Pictures/aesthetic.jpg";
  #     };
  #   };
  # };
}
