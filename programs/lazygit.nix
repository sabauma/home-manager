{ ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      showIcons = true;
      nerdFontsVersion = "3";

      git.commit.autoWrapCommitMessage = false;
      git.diffRenderers = [ { command = "difft --color=always"; external = true; } ];
    };
  };

}
