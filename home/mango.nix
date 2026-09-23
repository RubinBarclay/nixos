{ ... }:

{
  wayland.windowManager.mango = {
    enable = true;

    settings = {
      # animations = 0;
    };

    # extraConfig = ''
    #   xkb_rules_layout=se
    #
    #   borderpx=2
    #   gappih=6
    #   gappiv=6
    #   gappoh=6
    #   gappov=6
    #
    #   bind=SUPER,Return,spawn,foot
    #   bind=SUPER,m,quit
    #   bind=SUPER,q,killclient,
    #   bind=SUPER,r,reload_config
    #   bind=SUPER,Tab,focusstack,next
    #
    #   bind=ALT,Left,focusdir,left
    #   bind=ALT,Right,focusdir,right
    #   bind=ALT,Up,focusdir,up
    #   bind=ALT,Down,focusdir,down
    #
    #   bind=ALT,h,focusdir,left
    #   bind=ALT,l,focusdir,right
    #   bind=ALT,k,focusdir,up
    #   bind=ALT,j,focusdir,down
    #
    #   bind=ALT,backslash,togglefloating,
    #   bind=ALT,f,togglefullscreen,
    #
    #   bind=SUPER,d,spawn,fuzzel
    #
    #   bind=NONE,Print,spawn_shell,grim - | swappy -f -
    #
    #   bind=NONE,XF86AudioRaiseVolume,spawn,pamixer -i 5
    #   bind=NONE,XF86AudioLowerVolume,spawn,pamixer -d 5
    #   bind=NONE,XF86AudioMute,spawn,pamixer -t
    #
    #   bind=SUPER,l,spawn,swaylock
    #
    #   rootcolor=0x1e1e2eff
    #   bordercolor=0x45475aff
    #   focuscolor=0xcba6f7ff
    # '';
    extraConfig = ''
      xkb_rules_layout=se

      borderpx=2
      gappih=6
      gappiv=6
      gappoh=6
      gappov=6

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

      bind=SUPER,Return,spawn,foot
      bind=SUPER,m,quit
      bind=SUPER,q,killclient,
      bind=SUPER,r,reload_config
      bind=SUPER,Tab,focusstack,next

      bind=ALT,Left,focusdir,left
      bind=ALT,Right,focusdir,right
      bind=ALT,Up,focusdir,up
      bind=ALT,Down,focusdir,down

      bind=ALT,h,focusdir,left
      bind=ALT,l,focusdir,right
      bind=ALT,k,focusdir,up
      bind=ALT,j,focusdir,down

      bind=ALT,backslash,togglefloating,
      bind=ALT,f,togglefullscreen,

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
      nm-applet --indicator &
    '';
  };
  # swaybg -i ~/Pictures/aesthetic.jpg -m fill &
}
