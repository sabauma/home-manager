{ pkgs, ... }:

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
      "FindEmptyWorkspace.hs" = ./lib/FindEmptyWorkspace.hs;
      "Gruvbox.hs" = ./lib/Gruvbox.hs;
      "PerWorkspaceDirs.hs" = ./lib/PerWorkspaceDirs.hs;
      "PromptConfig.hs" = ./lib/PromptConfig.hs;
    };
  };
}
