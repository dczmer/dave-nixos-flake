# Common x/gnome/opengl/audio config.
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.baseSystem.gnome;
in
{
  options.baseSystem.gnome = {
    enable = mkEnableOption "Base Gnome configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };

    services.xserver.enable = true;
    programs.dconf.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.gnome.excludePackages = (
      with pkgs;
      [
        gnome-photos
        gnome-tour
        gedit
        cheese
        gnome-terminal
        epiphany
        geary
        evince
        totem
        gnome-music
        gnome-characters
        tali
        iagno
        hitori
        atomix
      ]
    );

    hardware.pulseaudio.enable = false;

    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = [
      #rocmPackages.clr.icd
    ];

    fonts = {
      packages = with pkgs; [
        material-design-icons
        noto-fonts
        noto-fonts-emoji
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
          ];
        })
      ];
      enableDefaultPackages = false;
      fontconfig.defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Color Sans"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    services.geoclue2.enable = true;
    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

    users.users.dave.extraGroups = [ "networkmanager" ];
  };
}
