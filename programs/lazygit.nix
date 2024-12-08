{ ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      showIcons = true;
      nerdFontsVersion = "3";

      git.commit.autoWrapCommitMessage = false;
      git.paging.externalDiffCommand = "difft --color=always";
    };
  };

}
