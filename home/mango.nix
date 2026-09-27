{ config, ... }:

let
  colors = config.lib.stylix.colors;
in
{
  wayland.windowManager.mango = {
    enable = true;

    settings = {
      # animations = 0;
    };

    extraConfig = ''
      xkb_rules_layout=se

      borderpx=2
      gappih=6
      gappiv=6
      gappoh=6
      gappov=6

      rootcolor=0x${colors.base00}ff
      bordercolor=0x${colors.base03}ff
      # base0A is Rosé Pine's "Rose" (#ebbcba) in the tinted-theming base16 port —
      # base0E lands on gold/orange in this scheme, not the purple/pink you'd
      # expect from the usual base16->ANSI convention.
      focuscolor=0x${colors.base0A}ff

      blur=1
      blur_layer=0
      blur_optimized=1
      blur_params_num_passes=2
      blur_params_radius=5
      blur_params_noise=0.02
      blur_params_brightness=0.9
      blur_params_contrast=0.9
      blur_params_saturation=1.0
      layer_animations=0

      shadows=1
      layer_shadows=0
      shadow_only_floating=0
      shadows_size=4
      shadows_blur=12
      shadows_position_x=2
      shadows_position_y=2
      shadowscolor=0x000000ff

      # Everything WM-level lives on SUPER (+SHIFT for the secondary/harder
      # action) so Alt and Ctrl stay completely free for apps, the terminal,
      # and zellij. The old ALT-based focusdir binds clashed directly with
      # Firefox's Alt+Left/Right back/forward navigation — that's the actual
      # bug this fixes, not just a style preference.
      bind=SUPER,Return,spawn,foot
      bind=SUPER,q,killclient,
      bind=SUPER+SHIFT,e,quit
      bind=SUPER+SHIFT,r,reload_config
      bind=SUPER,Tab,focusstack,next

      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down

      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down

      # SUPER+SHIFT+Space and SUPER+F match i3/sway's own defaults for these
      # two actions, which is exactly the kind of "common" binding you asked for.
      bind=SUPER+SHIFT,space,togglefloating,
      bind=SUPER,f,togglefullscreen,

      bind=SUPER,space,spawn,noctalia msg panel-toggle launcher
      bind=SUPER,s,spawn,noctalia msg panel-toggle control-center
      bind=SUPER,comma,spawn,noctalia msg settings-toggle
      bind=NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up
      bind=NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down
      bind=NONE,XF86AudioMute,spawn,noctalia msg volume-mute
      bind=NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up
      bind=NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down
    '';

    autostart_sh = ''
      noctalia &
    '';
  };
  # nm-applet --indicator &
  # swaybg -i ~/Pictures/aesthetic.jpg -m fill &
}
