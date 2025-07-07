{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.daveHome.tmux;
in
{
  options.daveHome.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      aggressiveResize = false;
      clock24 = true;
      escapeTime = 10;
      focusEvents = false;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = false;
      prefix = "C-a";
      terminal = "tmux-256color";
      newSession = true;
      extraConfig = ''
        set -g renumber-windows on
        set -s set-clipboard external

        set -g status-style bg='#111111',fg='#CCCCCC',us='#CCCCCC'
        set -g status-interval 1
        set -g status-left '#[fg=#4EA1FF]#{?window_zoomed_flag,󰍉 ,}[#S(#{session_attached})] '
        set -g status-left-length 20
        set -g status-right '#[fg=#4EA1FF]%Y-%m-%d %T %A'
        set -g status-right-length 50
        set-option -g status-position bottom
        set-option -g window-status-current-style fg=#BD5EFF
        set-option -g pane-border-style fg=#999999
        set-option -g pane-active-border-style fg=#4EA1FF

        bind-key j command-prompt -p "join pane from: " "join-pane -s '%%'"
        bind-key s command-prompt -p "join pane to: " "join-pane -t '%%'"
        bind-key b command-prompt "break-pane"

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

        # vim/tmux-navigator keybinds
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
        bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
        bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
        bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
        bind-key -T copy-mode-vi C-h select-pane -L
        bind-key -T copy-mode-vi C-j select-pane -D
        bind-key -T copy-mode-vi C-k select-pane -L
        bind-key -T copy-mode-vi C-l select-pane -R
      '';
    };
  };
}
