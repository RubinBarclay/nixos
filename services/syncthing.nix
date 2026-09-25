{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    # extraFlags = [ "--no-default-folder" ];
    user = "rustikk";
    group = "users";
    dataDir = "/home/rustikk"; # default location for new folders
    # configDir = "/home/rustikk/.config/syncthing";

    settings = {
      devices = {
        "toasterRTX" = {
          id = "U454DMS-VMSAOKO-5E4II56-RH525SC-TO4CKKL-LG76ZWG-D7N7TK2-3KZBFQC";
        };
        "OnePlus 15R" = {
          id = "R5P6N26-K6FID5B-DEKR575-SPGZKOU-TIC37S4-5UMBGS6-LM77DRX-MGSISQC";
        };
      };

      folders = {
        "KeePass" = {
          id = "keepass";
          path = "/home/rustikk/keepass";
          ignorePerms = false;
          devices = [
            "toasterRTX"
            "OnePlus 15R"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
