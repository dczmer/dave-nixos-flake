{
  pkgs,
  nur,
  dave-nvim-flake,
  ...
}:
{
  imports = [
    ./kitty.nix
    ./tmux.nix
    ./obsidian.nix
    ./logseq.nix
    ./zsh.nix
    ./firefox.nix
    ./gnome.nix
    ./hyprland.nix
    ./direnv.nix
  ];

  options.daveHome =
    {
    };

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
    nixpkgs.overlays = [ nur.overlays.default ];

    home = {
      username = "dave";
      homeDirectory = "/home/dave";
      stateVersion = "23.11";
      # user-level packages, but not dev stuff or single purpose apps.
      # those can be run through a dev env or nix-shell.
      packages = with pkgs; [
        p7zip
        unzip
        bat
        htop
        mplayer
        vlc
        mpv
        silver-searcher
        pinentry
        noto-fonts
        noto-fonts-emoji
        hack-font
        font-awesome
        dave-nvim-flake.packages.x86_64-linux.default
      ];
    };

    # simple borg backup script
    home.file."bin/backup.sh" = {
      source = ./scripts/backup.sh;
      recursive = true;
      executable = true;
    };

    home.file."Wallpapers" = {
      source = ./wallpaper;
    };

    programs.git = {
      enable = true;
      userName = "Dave Czmer";
      userEmail = "dczmer@gmail.com";
      extraConfig = {
        init = {
          defatulBranch = "master";
        };
      };
    };

    programs.ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
    services.ssh-agent.enable = true;

    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      config =
        {
        };
    };
    #services.taskwarrior-sync.enable = true;

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      # TODO: only if daveHome.gnome.enabled; else `cli`
      pinentry.package = pkgs.pinentry-gnome3;
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-update
        # XXX 2024-03-31 disabed because broken on latest version
        #exts.pass-audit
      ]);
      settings = {
        PASSWORD_STORE_DIR = "/home/dave/.password-store";
      };
    };

    # reload system units when changing config
    systemd.user.startServices = "sd-switch";

    programs.home-manager.enable = true;
  };
}
