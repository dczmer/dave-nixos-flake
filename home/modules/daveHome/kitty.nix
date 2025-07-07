{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.daveHome.kitty;
in
{
  options.daveHome.kitty = {
    enable = mkEnableOption "kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Hack Nerd Font";
      };
      shellIntegration.enableZshIntegration = true;
      themeFile = "Dark_Pastel";
      settings = {
        scrollback_lines = 50000;
        hide_window_decorations = true;
        background_opacity = "0.7";
        cursor = "none";
        custor_text_color = "#FFFFFF";
        clipboard_control = true;
        write_primary = true;
        write_clipboard = true;
        no_append = true;
        window_padding_width = 2;
      };
      package = pkgs.symlinkJoin {
        name = "kitty-tmux";
        paths = [ pkgs.kitty ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/kitty --add-flags "-e tmux new-session -AD -s dave"
        '';
      };
    };
    programs.zsh.shellAliases = {
      "icat" = "kitten icat";
    };
  };
}
