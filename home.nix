{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.mango.hmModules.mango
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  services.swaync.enable = true;

  home.stateVersion = "25.05";

  ##########
  # Mango
  ##########
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

  ##########
  # Waybar
  ##########
  # programs.waybar = {
  #   enable = true;
  #   # settings = "./waybar/config.jsonc";
  #   # style = "./waybar/style.css";
  # };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;
  };
  # programs.waybar.enable = true;
  # xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  # xdg.configFile."waybar/style.css".source = lib.mkForce ./waybar/style.css;

  # programs.waybar = {
  #   enable = true;
  #   settings = {
  #     mainBar = {
  #       layer = "top";
  #       position = "top";
  #       height = 30;
  #       spacing = 4;
  #
  #       modules-left = [ "clock" ];
  #       modules-center = [ "mango/workspaces" ];
  #       modules-right = [ "pulseaudio" "network" "battery" "tray" ];
  #
  #       "clock" = {
  #         format = "{:%H:%M   %a %d %b}";
  #       };
  #
  #       "battery" = {
  #         format = "{icon}  {capacity}%";
  #         format-icons = [ "" "" "" "" "" ];
  #         format-charging = "  {capacity}%";
  #       };
  #
  #       "network" = {
  #         format-wifi = "  {essid}";
  #         format-ethernet = "  Connected";
  #         format-disconnected = "睊 Offline";
  #       };
  #
  #       "pulseaudio" = {
  #         format = "{icon}  {volume}%";
  #         format-muted = "婢 Muted";
  #         format-icons = {
  #           default = [ "" "" "" ];
  #         };
  #       };
  #
  #       "tray" = {
  #         spacing = 8;
  #       };
  #     };
  #   };
  #   style = ''
  #     * {
  #       font-family: "JetBrainsMono Nerd Font";
  #       font-size: 13px;
  #     }
  #
  #     window#waybar {
  #       background-color: @base;
  #       color: @text;
  #     }
  #
  #     #clock, #battery, #network, #pulseaudio, #tray {
  #       padding: 0 10px;
  #       color: @text;
  #     }
  #
  #     #battery.charging {
  #       color: @green;
  #     }
  #
  #     #battery.warning:not(.charging) {
  #       color: @peach;
  #     }
  #
  #     #battery.critical:not(.charging) {
  #       color: @red;
  #     }
  #
  #     #workspaces button {
  #       padding: 0 5px;
  #       color: @subtext0;
  #     }
  #
  #     #workspaces button.active {
  #       color: @mauve;
  #     }
  #   '';
  # };

  ##########
  # Shell
  ##########
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      # nix rebuilds
      rebuild = "sudo nixos-rebuild switch --flake \"/etc/nixos#thinkToasterT430\"";
      rebuild-boot = "sudo nixos-rebuild boot --flake \"/etc/nixos#thinkToasterT430\""; # applies on next reboot
      rebuild-test = "sudo nixos-rebuild test --flake \"/etc/nixos#thinkToasterT430\""; # rebuild won't persist after reboot

      # rollback and cleanup
      rollback = "sudo nixos-rebuild switch --rollback"; # boots into previous build
      gc = "sudo nix-collect-garbage --delete-older-than 14d"; # keeps last 2 weeks builds
      gc-all = "sudo nix-collect-garbage -d"; # deletes old generations + unreferenced store paths

      # nix configs
      nixcfg = "sudo -e /etc/nixos/configuration.nix";
      homecfg = "sudo -e /etc/nixos/home.nix";
      flakecfg = "sudo -e /etc/nixos/flake.nix";

      # search nix package's
      nsearch = "nix search nixpkgs 2>/dev/null"; 

      # config shortcuts
      nvimrc = "nvim ~/.config/nvim/";
      mangorc = "nvim ~/.config/mango/config.conf";
      zshrc = "nvim ~/.config/zsh/";

      # colorized / friendlier output
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      ls = "eza --icons";
      df = "df -h";
      free = "free --mega -h";

      # confirm before clobbering
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

      # git
      Gs = "git status";
      Gcm = "git checkout main";
      Gcd = "git checkout dev";
    };

    sessionVariables = {
      MANWIDTH = "999";
      KEYTIMEOUT = "1";
    };

    initContent = ''
      # General options
      setopt autocd extendedglob nomatch menucomplete interactive_comments
      unsetopt BEEP
      _comp_options+=(globdots)
      stty stop undef
      
      # Try a package in a throwaway shell
      nshell() nix shell "nixpkgs#$1"; 

      # Enable completion menus
      autoload -Uz compinit
      compinit
      zmodload zsh/complist

      # History search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^p" up-line-or-beginning-search
      bindkey "^n" down-line-or-beginning-search
      bindkey "^k" up-line-or-beginning-search
      bindkey "^j" down-line-or-beginning-search

      # PATH additions
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/.local/share/go/bin:$PATH"
      export GOPATH="$HOME/.local/share/go"
      export PATH="$PATH:./node_modules/.bin"

      # Vi-mode
      bindkey -v
      bindkey -M menuselect '^h' vi-backward-char
      bindkey -M menuselect '^k' vi-up-line-or-history
      bindkey -M menuselect '^l' vi-forward-char
      bindkey -M menuselect '^j' vi-down-line-or-history
      bindkey -M menuselect '^[[Z' vi-up-line-or-history
      bindkey -v '^?' backward-delete-char

      # Cursor shape per vi mode
      function zle-keymap-select () {
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q';;      # block
          viins|main) echo -ne '\e[5 q';; # beam
        esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q'; }
    '';

    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "master";
          sha256 = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  ##########
  # Editor / terminal tools
  ##########
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --hidden -l ''";
    tmux.enableShellIntegration = false; # you're on zellij, not tmux
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Rubin Barclay";
        email = "63505731+RubinBarclay@users.noreply.github.com";
      };
      credential.helper = "cache";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk.enable = true;

  ##########
  # Session variables
  ##########
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "foot";
    BROWSER = "firefox";
    PAGER = "nvim +Man!";
  };

  programs.swaylock.enable = true;

  ##########
  # Packages
  ##########
  home.packages = with pkgs; [
    foot
    eza
    ripgrep
    fd
    bat
    fzf
    wget
    unzip

    # audio
    pamixer
    wiremix

    # wayland essentials
    wl-clipboard
    fuzzel
    
    # screenshots
    grim
    slurp
    swappy

    # wallpaper
    swaybg

    # lock screen
    swayidle

    # browser
    firefox

    # bluetooth
    blueman

    # networking
    wireshark
    nmap
    tcpdump
    traceroute
  ];
}
