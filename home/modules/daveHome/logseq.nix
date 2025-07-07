# interesting alternative to obsidian, but very different concepts and seems to be broken on nixos.
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.daveHome.logseq;
in
{
  options.daveHome.logseq = {
    enable = mkEnableOption "Logseq KMS";
  };

  config = mkIf cfg.enable {
    # NOTE this is for logseq :(
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    home.packages = [ pkgs.logseq ];
  };
}
