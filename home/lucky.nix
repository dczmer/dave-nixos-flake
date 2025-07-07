{
  pkgs,
  ...
}:
{
  imports = [
    ./modules/daveHome
    ./modules/dave-i3config
  ];

  daveHome.kitty.enable = true;
  daveHome.tmux.enable = true;
  daveHome.obsidian.enable = true;
  daveHome.logseq.enable = true;
  daveHome.zsh.enable = true;
  daveHome.gnome.enable = true;
  daveHome.hyprland.enable = false;
  daveHome.direnv.enable = true;

  dave-i3config.enable = true;
  dave-i3config.i3BlocksBatteryBar = false;
  dave-i3config.i3BlocksWifiBar = false;

  programs.kitty.font.size = 14;

  # NOTE: run `dconf watch /` and change settings in control panel
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "kitty.desktop"
        "obsidian.desktop"
        "logseq.desktop"
        "spotify.desktop"
        "steam.desktop"
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "/home/dave/Wallpapers/nix-wallpaper-mosaic-blue.png";
      picture-uri-dark = "/home/dave/Wallpapers/nix-wallpaper-simple-dark-gray.png";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 7200;
    };
    "org/gnome/desktop/session" = {
      idle-delay = 1200;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
    };
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };

    # TODO: extract to daveHome.libVert
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.packages = with pkgs; [
    handbrake
    spotify
    gimp
    libreoffice
  ];

  programs.ssh.matchBlocks = {
    "guinness" = {
      user = "dave";
      port = 6969;
      identityFile = "/home/dave/.ssh/keys/id_ed25519";
    };
  };

  programs.zsh.shellAliases = {
    "nvim" = "nix run ~/source/dave-nvim-lazy --";
  };
}
