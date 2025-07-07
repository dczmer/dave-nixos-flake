{
  config,
  font,
  bgColor,
  borderColor,
  textColor,
  selectedBgColor,
  windowBorderColor,
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  "*" = {
    "background-color" = mkLiteral bgColor;
    "border-color" = mkLiteral borderColor;
    "font" = font;
    "text-color" = mkLiteral textColor;
  };
  "window" = {
    "width" = mkLiteral "100%";
    "padding" = mkLiteral "8px";
    "anchor" = mkLiteral "north";
    "location" = mkLiteral "north";
    "children" = [ "horibox" ];
    "border" = mkLiteral "1px";
    "border-color" = mkLiteral windowBorderColor;
  };
  "horibox" = {
    "orientation" = mkLiteral "horizontal";
    "children" = [
      "entry"
      "listview"
    ];
  };
  "listview" = {
    "layout" = mkLiteral "horizontal";
    "spacing" = mkLiteral "4px";
    "lines" = mkLiteral "100";
  };
  "entry" = {
    "placeholder" = "Run...";
    "width" = mkLiteral "10.0em";
    "expand" = false;
    "text-color" = mkLiteral "#FFBD5E";
  };
  "element" = {
    "padding" = mkLiteral "2px 4px";
  };
  "element-text" = {
    "background-color" = mkLiteral "inherit";
  };
  "element-icon" = {
    "background-color" = mkLiteral "inherit";
  };
  "element selected" = {
    "background-color" = mkLiteral bgColor;
    "border-color" = mkLiteral "#BD5EFF";
    "border" = mkLiteral "1px";
  };
  "element-text selected" = {
    "text-color" = mkLiteral "#BD5EFF";
  };
}
