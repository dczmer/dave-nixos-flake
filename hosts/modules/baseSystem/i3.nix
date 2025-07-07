# Common x/gnome/opengl/audio config.
#
# Config implemented in home-manager modules.
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.baseSystem.i3;
in
{
  options.baseSystem.i3 = {
    enable = mkEnableOption "i3 base sysetm config";
  };

  config = mkIf cfg.enable {
    # links /libexec from derivations to /run/current-system/sw
    environment.pathsToLink = [ "/libexec" ];
    services.xserver.enable = true;
    programs.dconf.enable = true;
    # this is IMPORTANT. you can't just include it as a package.
    programs.i3lock.enable = true;
    services.displayManager = {
      gdm.enable = true;
    };
    services.displayManager.defaultSession = "none+i3";
    services.gnome.gnome-keyring.enable = true;
    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3blocks
        i3lock
        xss-lock
        xidlehook
        betterlockscreen
        feh
        xorg.xmodmap
        xorg.xev
        playerctl
        pavucontrol
        brightnessctl
        simplescreenrecorder
        screenkey
        scrot
        drawing
        sysstat
        hack-font
        acpi
        bc
        jq
        procps
        wireplumber
        util-linux
      ];
    };
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
    # TODO: geoclue doesn't actually work any more, but with out this
    # i can't figure out how to get redshift to build.
    location.provider = "geoclue2";
    services.redshift = {
      enable = true;
    };
    services.picom.enable = true;
  };
}
