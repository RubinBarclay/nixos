{ pkgs, ... }:

{
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
      rebuild = "sudo nixos-rebuild switch --flake \"/home/rustikk/nixos#thinkToasterT430\"";
      rebuild-boot = "sudo nixos-rebuild boot --flake \"/home/rustikk/nixos#thinkToasterT430\"";
      rebuild-test = "sudo nixos-rebuild test --flake \"/home/rustikk/nixos#thinkToasterT430\"";

      rollback = "sudo nixos-rebuild switch --rollback";
      gc = "sudo nix-collect-garbage --delete-older-than 14d";
      gc-all = "sudo nix-collect-garbage -d";

      nixcfg = "nvim ~/nixos/configuration.nix";
      homecfg = "nvim ~/nixos/home/default.nix";
      flakecfg = "nvim ~/nixos/flake.nix";

      nsearch = "nix search nixpkgs 2>/dev/null";

      nvimrc = "nvim ~/.config/nvim/";
      mangorc = "nvim ~/.config/mango/config.conf";
      zshrc = "nvim ~/.config/zsh/";

      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      ls = "eza --icons";
      df = "df -h";
      free = "free --mega -h";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

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
          vicmd) echo -ne '\e[1 q';;
          viins|main) echo -ne '\e[5 q';;
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
}
