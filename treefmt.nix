{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Fish
  programs.fish_indent.enable = true;

  # Haskell
  programs.hlint.enable = true;
  programs.stylish-haskell.enable = true;

  # Nix
  programs.nixfmt.enable = true;

  # Shell
  programs.shfmt.enable = true;

  # Stylua
  programs.stylua.enable = true;
  settings.formatter.stylua.options = [
    "--config-path=${./.stylua.toml}"
  ];
}
