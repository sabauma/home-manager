{ ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      showIcons = true;
      nerdFontsVersion = "3";

      git.commit.autoWrapCommitMessage = false;
      git.diffRenderers = [
        {
          type = "extDiff";
          command = "difft --color=always";
        }
      ];
    };
  };

}
