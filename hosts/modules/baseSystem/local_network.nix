# Common settings for my local network.
{
  config,
  ...
}:

let
  cfg = config.baseSystem.network;
in
{
  options.baseSystem.network = {

    # TODO: custom ca cert is broken; needs to be managed in the store, i think.
    ## TODO: this location for my custom CA cert may not be appropriate.
    ##       probably need to make it a derivation or copy it to the nix
    ##       store first.
    #certificateFiles = mkOption {
    #  type = types.listOf types.path;
    #  default = [
    #    /var/certs/daveCA.pem
    #  ];
    #};
  };

  config = {
    security.pki.certificateFiles = cfg.certificateFiles;
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "8.8.8.8" ];
    networking.firewall.enable = true;
  };
}
