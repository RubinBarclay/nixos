{ pkgs, ... }:
{
  users.users.rustikk = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    shell = pkgs.zsh;
  };

  console.keyMap = "sv-latin1";

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "esc";
        };

        meta = {
          capslock = "capslock";
        };
      };
    };
  };
}
