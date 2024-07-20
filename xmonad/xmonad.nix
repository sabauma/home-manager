{ ... }:

{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = ps: with ps; [
      xmonad
      xmonad-contrib
      xmonad-extras
      hashable
      text-icu
      vector
      xmobar
    ];

    config = ./xmonad.hs;
    libFiles = {
      "FindEmptyWorkspace.hs" = ./FindEmptyWorkspace.hs;
      "Gruvbox.hs" = ./Gruvbox.hs;
      "PerWorkspaceDirs.hs" = ./PerWorkspaceDirs.hs;
      "PromptConfig.hs" = ./PromptConfig.hs;
    };
  };
}
