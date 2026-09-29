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
      bind=SUPER,m,switch_layout

      # Swap the focused window with its neighbor — mango's direct equivalent
      # of the old bspwm super+shift+hjkl swap binds.
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down

      # Resize the focused window — ported from the old bspwm super+ctrl+hjkl
      # resize binds.
      bind=SUPER+CTRL,h,resizewin,-50,+0
      bind=SUPER+CTRL,l,resizewin,+50,+0
      bind=SUPER+CTRL,k,resizewin,+0,-50
      bind=SUPER+CTRL,j,resizewin,+0,+50
      bind=SUPER+CTRL,Left,resizewin,-50,+0
      bind=SUPER+CTRL,Right,resizewin,+50,+0
      bind=SUPER+CTRL,Up,resizewin,+0,-50
      bind=SUPER+CTRL,Down,resizewin,+0,+50

      # Drag-to-move / drag-to-resize — mango's own stock default, standard
      # across most WMs (SUPER+drag).
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize

      # Workspaces (mango calls them tags). SUPER+N to switch, SUPER+SHIFT+N
      # to bring the focused window along — same switch/bring-along split as
      # the rest of the SUPER+SHIFT binds above. N/B step to the next/prev
      # workspace instead of brackets — this keyboard doesn't have a
      # conveniently-placed bracket key.
      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0

      bind=SUPER+SHIFT,1,tag,1,0
      bind=SUPER+SHIFT,2,tag,2,0
      bind=SUPER+SHIFT,3,tag,3,0
      bind=SUPER+SHIFT,4,tag,4,0
      bind=SUPER+SHIFT,5,tag,5,0
      bind=SUPER+SHIFT,6,tag,6,0
      bind=SUPER+SHIFT,7,tag,7,0
      bind=SUPER+SHIFT,8,tag,8,0
      bind=SUPER+SHIFT,9,tag,9,0

      bind=SUPER+SHIFT,n,viewtoright,0
      bind=SUPER+SHIFT,b,viewtoleft,0

      bind=SUPER,d,spawn,noctalia msg panel-toggle launcher
      bind=SUPER,s,spawn,noctalia msg panel-toggle control-center
      bind=SUPER+SHIFT,s,spawn,noctalia msg screenshot-region
      bind=SUPER,comma,spawn,noctalia msg settings-toggle
      # SUPER+V for clipboard history matches Windows' own Win+V — about as
      # standard/memorable as this gets.
      bind=SUPER,v,spawn,noctalia msg panel-toggle clipboard
      bind=SUPER,p,spawn,noctalia msg panel-toggle session
      # SUPER+L collides with the vim-style hjkl focusdir bind above, so lock
      # goes on SUPER+Escape instead.
      bind=SUPER,Escape,spawn,noctalia msg session lock
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
