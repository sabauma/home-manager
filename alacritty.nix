{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      font = {
        size = 8;
        normal = {
          family = "Development";
          style = "Regular";
        };
        bold = {
          family = "Development";
          style = "Bold";
        };
        italic = {
          family = "Development";
          style = "Italic";
        };
        bold_italic = {
          family = "Development";
          style = "Bold Italic";
        };
      };

      colors.draw_bold_text_with_bright_colors = false;

      colors.primary = {
        background = "0x1d2021";
        foreground = "0xebdbb2";
      };

      colors.normal = {
        black   = "0x282828";
        red     = "0xcc241d";
        green   = "0x98971a";
        yellow  = "0xd79921";
        blue    = "0x458588";
        magenta = "0xb16286";
        cyan    = "0x689d6a";
        white   = "0xa89984";
      };

      colors.bright = {
        black   = "0x928374";
        red     = "0xfb4934";
        green   = "0xb8bb26";
        yellow  = "0xfabd2f";
        blue    = "0x83a598";
        magenta = "0xd3869b";
        cyan    = "0x8ec07c";
        white   = "0xebdbb2";
      };

      shell = "${pkgs.fish}/bin/fish";
    };
  };
}
