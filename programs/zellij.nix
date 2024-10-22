{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      default_shell = "${pkgs.fish}/bin/fish";
      scrollback_editor = "${pkgs.neovim}/bin/nvim";
      pane_frames = false;

      theme = "gruvbox-dark";
      themes = {
        gruvbox-dark = {
          fg = "#D5C4A1";
          bg = "#282828";
          black = "#3C3836";
          red = "#CC241D";
          green = "#98971A";
          yellow = "#D79921";
          blue = "#3C8588";
          magenta = "#B16286";
          cyan = "#689D6A";
          white = "#FBF1C7";
          orange = "#D65D0E";
        };
      };
    };
  };
}