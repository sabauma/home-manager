{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Enable formatting of this files
  programs.fish_indent.enable = true;
  programs.hlint.enable = true;
  programs.nixfmt.enable = true;
  programs.stylish-haskell.enable = true;
}
