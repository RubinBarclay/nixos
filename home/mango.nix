{ ... }:

{
  wayland.windowManager.mango = {
    enable = true;

    settings = {
      animations = 0;
    };

    extraConfig = ''
      xkb_rules_layout=se

      borderpx=2
      gappih=6
      gappiv=6
      gappoh=6
      gappov=6

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

      bind=SUPER,d,spawn,fuzzel

      bind=NONE,Print,spawn_shell,grim - | swappy -f -

      bind=NONE,XF86AudioRaiseVolume,spawn,pamixer -i 5
      bind=NONE,XF86AudioLowerVolume,spawn,pamixer -d 5
      bind=NONE,XF86AudioMute,spawn,pamixer -t

      bind=SUPER,l,spawn,swaylock

      rootcolor=0x1e1e2eff
      bordercolor=0x45475aff
      focuscolor=0xcba6f7ff
    '';

    autostart_sh = ''
      nm-applet --indicator &
      swaybg -i ~/Pictures/aesthetic.jpg -m fill &
    '';
  };
}
