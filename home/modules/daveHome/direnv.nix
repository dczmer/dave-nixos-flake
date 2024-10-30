{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.daveHome.direnv;
in
{
  options.daveHome.direnv = {
    enable = mkEnableOption "direnv integration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      # XXX some note about this only being compatible with (new) bash?
      nix-direnv.enable = true;
    };
  };
}
