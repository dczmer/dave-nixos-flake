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
  daveHome.zsh.enable = true;
  daveHome.gnome.enable = true;
  daveHome.direnv.enable = true;
  daveHome.hyprland.enable = false;
  daveHome.obsidian.enable = true;
  daveHome.logseq.enable = false;

  dave-i3config.enable = true;
  dave-i3config.i3BlocksBatteryBar = true;
  dave-i3config.i3BlocksWifiBar = true;

  programs.kitty.font.size = 11;

  # NOTE: run `dconf watch /` and change settings in control panel
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "kitty.desktop"
        "obsidian.desktop"
        "spotify.desktop"
        "steam.desktop"
        "gnucash.desktop"
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "/home/dave/Wallpapers/nix-wallpaper-mosaic-blue.png";
      picture-uri-dark = "/home/dave/Wallpapers/nix-wallpaper-simple-dark-gray.png";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      power-saver-profile-on-low-battery = true;
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 900;
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/desktop/session" = {
      idle-delay = 300;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
    };
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };
    "org/gnome/desktop/peripherials/touchpad" = {
      tap-to-click = true;
      speed = 2.0;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.packages = with pkgs; [
    spotify
    gimp
    libreoffice
    gnucash
  ];

  programs.ssh.matchBlocks = {
    "guinness" = {
      user = "dave";
      port = 6969;
      identityFile = "/home/dave/.ssh/keys/id_ed25519";
    };
    "lucky" = {
      user = "dave";
      port = 6969;
    };
  };

  programs.zsh.shellAliases = {
    # This assumes you have installed sshfs-fuse via your nixos system
    # config (or is otherwise in your active env).
    # The host also needs to have a /mnt/Documents dir with perms
    # dave:users and an ssh-key that is registered with the server.
    # i did this because setting up an fstab and systemd automount for a
    # share with a passphrase-protected key is a PITA.
    "mnt-documents" =
      "sshfs -v -p6969 dave@guinness:/backup/Documents /mnt/Documents -o user,uid=$(id -u dave),gid=$(id -g dave),noatime,nosuid,_netdev,noauto,dir_cache=no,nodev";
    "umount-documents" = "fusermount3 -u /mnt/Documents";
    "view-documents" =
      "if ! mountpoint /mnt/Documents > /dev/null 2>&1; then mnt-documents; fi; nautilus /mnt/Documents";
    "sync-docs" = "rsync -advl /home/dave/Documents/ guinness:/backup/Documents/";
    "nvim" = "nix run ~/source/dave-nvim-lazy --";
  };
}
