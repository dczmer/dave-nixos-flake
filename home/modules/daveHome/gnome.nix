{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.daveHome.gnome;
in
{
  options.daveHome.gnome = {
    enable = mkEnableOption "gnome3";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    home.sessionVariables.GTK_THEME = "Materia-dark";

    # NOTE: run `dconf watch /` and change settings in control panel
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/desktop/preferences" =
        {
        };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
    };
    home.packages = with pkgs; [
      eog
      xdg-desktop-portal-gnome
      xdg-utils
    ];

    ## TODO: this is supposed to make a gnome launcher that i can click to mount the documents folder.
    ## it keeps failing with `Bad message` no idea...
    ## once it's working, wanted to pin it to the quick launch bar.
    ## for now, i guess just run `view-documents` from the command line.
    #xdg.desktopEntries = {
    #  mnt-documents = {
    #    name = "Documents (Share)";
    #    exec = "nvim";
    #    terminal = true;
    #    type = "Application";
    #    icon = "nautilus";
    #    categories = [ "Application" ];
    #  };
    #};
  };
}
