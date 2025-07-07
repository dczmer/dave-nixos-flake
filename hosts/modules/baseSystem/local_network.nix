# Common settings for my local network.
{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.baseSystem.network;
in
{
  options.baseSystem.network = {

    # TODO: this location for my custom CA cert may not be appropriate.
    #       probably need to make it a derivation or copy it to the nix
    #       store first.
    certificateFiles = mkOption {
      type = types.listOf types.path;
      default = [
        /var/certs/daveCA.pem
      ];
    };
  };

  config = {
    security.pki.certificateFiles = cfg.certificateFiles;
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "8.8.8.8" ];
    networking.firewall.enable = true;
  };
}
