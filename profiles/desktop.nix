{ pkgs, ... }:
{
  # Laptops/desktops with a real Wayland session (mango). Bare-metal boot
  # method is a separate concern — pair this with systemd-boot-efi.nix (or
  # whatever the box actually needs) at the host level, not bundled here.

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  users.users.rustikk.extraGroups = [ "networkmanager" ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd mango";
        user = "greeter";
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  # Physical keyboard remap — only meaningful with real hardware attached.
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
