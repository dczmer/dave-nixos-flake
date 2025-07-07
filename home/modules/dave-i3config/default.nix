{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dave-i3config;
  i3-scripts = import ./i3-scripts.nix { packages = pkgs; };
  i3FontType = types.submodule {
    options = {
      names = mkOption {
        type = types.listOf types.str;
        default = [ "Hack Nerd Font" ];
      };
      size = mkOption {
        type = types.float;
        default = 12.0;
      };
    };
  };
in
{
  options.dave-i3config = {
    enable = mkEnableOption "dave-i3config";
    mod = mkOption {
      default = "Mod4";
      type = types.str;
    };
    term = mkOption {
      default = "kitty";
      type = types.str;
    };
    browser = mkOption {
      default = "chromium";
      type = types.str;
    };
    # I mostly just use 2 named workspaces
    workspace1 = mkOption {
      default = "1 Terminal ";
      type = types.str;
    };
    workspace2 = mkOption {
      default = "2 Chromium ";
      type = types.str;
    };
    lockAfter = mkOption {
      default = 360;
      type = types.int;
    };
    suspendAfter = mkOption {
      default = 600;
      type = types.int;
    };
    i3BgColor = mkOption {
      default = "#000000";
      type = types.str;
    };
    i3InactiveBgColor = mkOption {
      default = "#222222";
      type = types.str;
    };
    i3TextColor = mkOption {
      default = "#f3f4f5";
      type = types.str;
    };
    i3InactiveTextColor = mkOption {
      default = "#676E7D";
      type = types.str;
    };
    i3UrgetnBgColor = mkOption {
      default = "#F79494";
      type = types.str;
    };
    i3IndicatorColor = mkOption {
      default = "#00ff00";
      type = types.str;
    };
    i3Font = mkOption {
      type = i3FontType;
      default = {
        names = [ "Hack Nerd Font" ];
        size = 14.0;
      };
    };
    i3BarFont = mkOption {
      type = i3FontType;
      default = {
        names = [ "Hack Nerd Font" ];
        size = 14.0;
      };
    };
    rofiFont = mkOption {
      default = "Hack Nerd Font 14";
      type = types.str;
    };
    rofiBgColor = mkOption {
      default = "#222222";
      type = types.str;
    };
    rofiBorderColor = mkOption {
      default = "White";
      type = types.str;
    };
    rofiTextColor = mkOption {
      default = "White";
      type = types.str;
    };
    rofiSelectedBgColor = mkOption {
      default = "#676e7d";
      type = types.str;
    };
    rofiWindowBorderColor = mkOption {
      default = "#676e7d";
      type = types.str;
    };
    i3BlocksBatteryBar = mkOption {
      default = false;
      type = types.bool;
    };
    i3BlocksWifiBar = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      i3-scripts
      rofi-network-manager
      pkgs.adwaita-icon-theme
      xclip
      xdotool
    ];

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config =
        let
          mod = cfg.mod;
          lockAfter = builtins.toString cfg.lockAfter;
          suspendAfter = builtins.toString cfg.suspendAfter;
          workspace1 = cfg.workspace1;
          workspace2 = cfg.workspace2;
          bgColor = cfg.i3BgColor;
          inactiveBgColor = cfg.i3InactiveBgColor;
          textColor = cfg.i3TextColor;
          inactiveTextColor = cfg.i3InactiveTextColor;
          urgentBgColor = cfg.i3UrgetnBgColor;
          indicatorColor = cfg.i3IndicatorColor;
        in
        {
          modifier = "${mod}";
          terminal = "${cfg.term}";
          fonts = cfg.i3Font;
          focus = {
            followMouse = true;
            newWindow = "smart";
          };
          gaps = {
            outer = 0;
            inner = 12;
            smartGaps = true;
          };
          colors = {
            focused = {
              border = bgColor;
              childBorder = bgColor;
              background = bgColor;
              text = textColor;
              indicator = indicatorColor;
            };
            unfocused = {
              border = inactiveBgColor;
              childBorder = inactiveBgColor;
              background = inactiveBgColor;
              text = inactiveTextColor;
              indicator = indicatorColor;
            };
            focusedInactive = {
              border = inactiveBgColor;
              childBorder = inactiveBgColor;
              background = inactiveBgColor;
              text = inactiveTextColor;
              indicator = indicatorColor;
            };
            urgent = {
              border = urgentBgColor;
              childBorder = urgentBgColor;
              background = urgentBgColor;
              text = textColor;
              indicator = indicatorColor;
            };
          };
          floating = {
            modifier = "${mod}";
            criteria = [
              { "title" = "SimpleScreenRecorder"; }
              { "title" = "Drawing"; }
            ];
          };
          defaultWorkspace = workspace1;
          workspaceAutoBackAndForth = true;
          # NOTE:
          # See https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/i3.nix
          # In order to override default keybindings from that module, you must use EXACT casing:
          # - letters, "minus", "space" = lowercase
          # - Shift, Return, Arrow keys = (Capitalized)
          keybindings = lib.mkOptionDefault {
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+Shift+e" = "exec i3-nagbar -t warning -n 'Exit?' -b 'Yes' 'i3-msg exit'";

            "${mod}+d" = "exec --no-startup-id rofi -config ~/.config/rofi/config.rasi -show combi";
            "${mod}+n" = "exec --no-startup-id rofi-network-manager";
            "${mod}+Return" = "exec ${cfg.term}";
            "${mod}+Shift+Return" = "exec ${cfg.browser}";
            "${mod}+q" = "kill";
            "${mod}+r" = "mode resize";

            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            "${mod}+quote" = "split h";
            "${mod}+%" = "split v";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";
            "${mod}+a" = "focus parent";
            "${mod}+Shift+a" = "focus child";

            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";

            "${mod}+1" = "workspace ${workspace1}";
            "${mod}+2" = "workspace ${workspace2}";
            "${mod}+3" = "workspace 3";
            "${mod}+4" = "workspace 4";
            "${mod}+Shift+1" = "move container to workspace ${workspace1}";
            "${mod}+Shift+2" = "move container to workspace ${workspace2}";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";

            "Control+Shift+l" = "exec --no-startup-id betterlockscreen -l dim";
            "Control+F12" = "exec --no-startup-id ${i3-scripts}/bin/screenshot.sh";
            "Control+Shift+F12" = "exec --no-startup-id ${i3-scripts}/bin/screenshot.sh -ub";

            "${mod}+Shift+Left" = "move container to workspace left";
            "${mod}+Shift+Right" = "move container to workspace right";
            "${mod}+Shift+Up" = "move container to workspace up";
            "${mod}+Shift+Down" = "move container to workspace down";

            "XF86AudioMute" = "exec --no-startup-id ${i3-scripts}/bin/volume.sh mute";
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${i3-scripts}/bin/volume.sh up";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${i3-scripts}/bin/volume.sh down";
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
            "XF86MonBrightnessUp" = "exec --no-startup-id ${i3-scripts}/bin/display.sh up";
            "XF86MonBrightnessDown" = "exec --no-startup-id ${i3-scripts}/bin/display.sh down";
          };
          modes = {
            resize = {
              "h" = "resize shrink width 10 px or 10 ppt";
              "j" = "resize grow height 10 px or 10 ppt";
              "k" = "resize shrink height 10 px or 10 ppt";
              "l" = "resize grow width 10 px or 10 ppt";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
          };
          assigns = {
            "${workspace1}" = [ { class = "kitty"; } ];
            "${workspace2}" = [ { class = "Chromium"; } ];
          };
          startup = [
            {
              command = "eval $(ssh-agent -s)";
              notification = false;
            }
            {
              command = "betterlockscreen -w dim";
              notification = false;
            }
            {
              command = "xidlehook --not-when-audio --timer ${lockAfter} 'betterlockscreen -l dim' '' --timer ${suspendAfter} 'systemctl suspend-then-hibernate' ''&";
              notification = false;
            }
            {
              command = "xss-lock -- betterlockscreen -l dim &";
              notification = false;
            }
            {
              command = "redshift -l 42.28:-83.73";
              notification = false;
            }
            {
              command = "xmodmap ${i3-scripts}/bin/remapcapslock -display :0";
              notification = false;
            }
            {
              command = cfg.term;
              notification = false;
            }
          ];
          bars = [
            {
              command = "i3bar";
              statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ~/.config/i3blocks/bottom 2>&1";
              position = "bottom";
              trayPadding = 0;
              trayOutput = "primary";
              fonts = cfg.i3BarFont;
              mode = "hide";
              hiddenState = "hide";
              workspaceNumbers = false;
              colors = {
                background = inactiveBgColor;
                separator = inactiveBgColor;
                focusedWorkspace = {
                  border = "#BD4EFF";
                  background = bgColor;
                  text = "#BD4EFF";
                };
                activeWorkspace = {
                  border = bgColor;
                  background = bgColor;
                  text = textColor;
                };
                inactiveWorkspace = {
                  border = inactiveBgColor;
                  background = inactiveBgColor;
                  text = inactiveTextColor;
                };
                urgentWorkspace = {
                  border = urgentBgColor;
                  background = urgentBgColor;
                  text = textColor;
                };
              };
              extraConfig = ''
                modifier ${mod}
                padding 0
              '';
            }
          ];
        };
      extraConfig = ''
        for_window [class=".*"] border pixel 1
        for_window [urgent="latest"] focus
        popup_during_fullscreen smart

        bindsym --release ${cfg.mod}+c exec xdotool key --clearmodifiers ctrl+shift+c
        bindsym --release ${cfg.mod}+v exec xdotool key --clearmodifiers ctrl+shift+v
      '';
    };

    programs.i3blocks = {
      enable = true;
      package = pkgs.i3blocks;
      bars =
        let
          batteryBar = {
            battery = hm.dag.entryBetween [ "media" ] [ "temp" ] {
              command = "bash ${i3-scripts}/bin/battery.bash 2>/dev/null";
              interval = 3;
              markup = "pango";
            };
          };
          wifiBar = {
            network = hm.dag.entryBetween [ "media" ] [ "temp" ] {
              command = "bash ${i3-scripts}/bin/network.bash 2>/dev/null";
              interval = 3;
              markup = "pango";
            };
          };
        in
        {
          bottom =
            {
              taskw = hm.dag.entryBefore [ "disk" ] {
                command = "bash ${i3-scripts}/bin/taskw.bash 2>/dev/null";
                interval = 30;
                markup = "pango";
                align = "left";
                color = "#ffbd5e";
              };
              disk = hm.dag.entryBefore [ "memory" ] {
                command = "bash ${i3-scripts}/bin/disk.bash 2>/dev/null";
                interval = 30;
                markup = "pango";
              };
              memory = hm.dag.entryBefore [ "cpu" ] {
                command = "bash ${i3-scripts}/bin/memory.bash 2>/dev/null";
                interval = 5;
                markup = "pango";
              };
              cpu = hm.dag.entryBefore [ "loadavg" ] {
                command = "bash ${i3-scripts}/bin/cpu_usage.bash 2>/dev/null";
                interval = 5;
                markup = "pango";
              };
              loadavg = hm.dag.entryBefore [ "temp" ] {
                command = "bash ${i3-scripts}/bin/loadavg.bash 2>/dev/null";
                interval = 3;
                markup = "pango";
              };
              temp = hm.dag.entryBefore [ "media" ] {
                command = "bash ${i3-scripts}/bin/thermal.bash 2>/dev/null";
                interval = 5;
                markup = "pango";
              };
              media = hm.dag.entryBefore [ "time" ] {
                command = "bash ${i3-scripts}/bin/media.bash 2>/dev/null";
                interval = 3;
                markup = "pango";
              };
              time = {
                command = "echo ' ' $(date +'%Y-%m-%d %T %A') ' '";
                interval = 1;
                background = cfg.i3InactiveBgColor;
                color = "#4EA1FF";
              };
            }
            // (if cfg.i3BlocksBatteryBar then batteryBar else { })
            // (if cfg.i3BlocksWifiBar then wifiBar else { });
        };
    };

    programs.rofi =
      let
        rofi-theme = import ./rofi-theme.nix {
          inherit config;
          font = cfg.rofiFont;
          bgColor = cfg.rofiBgColor;
          borderColor = cfg.rofiBorderColor;
          textColor = cfg.rofiTextColor;
          selectedBgColor = cfg.rofiSelectedBgColor;
          windowBorderColor = cfg.rofiWindowBorderColor;
        };
      in
      {
        enable = true;
        modes = [
          "combi"
          "run"
          "drun"
          "ssh"
        ];
        font = cfg.rofiFont;
        extraConfig = {
          "combi-modes" = "run,drun";
          "fixed-num-lines" = true;
          "show-icons" = true;
        };
        theme = rofi-theme;
      };

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      settings = {
        global = {
          width = 400;
          #height = "(0,300)";
          #offset = "(10,10)";
          geometry = "0x4-10+10";
          origin = "top-right";
          transparency = 10;
          frame_color = "#f3f4f5";
          font = "Hack Nerd Font 10";
          icon_path = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/symbolic/status";
          frame_width = 1;
          markup = "yes";
          fromat = "%s %p\\n%b";
          sort = "yes";
          indicate_hidden = "yes";
          alignment = "left";
          bounce_freq = 5;
          show_age_threshold = 60;
          word_wrap = "no";
          ignore_newline = "no";
          shrink = "yes";
          idle_threshold = 120;
          monitor = 0;
          follow = "none";
          sticky_history = "yes";
          history_length = 20;
          show_indicators = "yes";
          line_height = 0;
          separator_height = 1;
          padding = 8;
          horizontal_padding = 10;
          separator_color = "auto";
          startup_notifications = "false";
          icon_position = "left";
          max_icon_size = 128;
        };
        urgency_low = {
          background = "#676E7D";
          foreground = "#f3f4f5";
          timeout = 6;
          default_icon = "dialog-information-symbolic";
        };
        urgency_normal = {
          background = "#f3f4f5";
          foreground = "#676E7D";
          timeout = 10;
          override_pause_level = 30;
          default_icon = "dialog-information-symbolic";
        };
        urgency_critical = {
          background = "#F79494";
          foreground = "#222222";
          timeout = 0;
          override_pause_level = 60;
          default_icon = "dialog-warning-symbolic";
        };
      };
    };

  };
}
