{
  pkgs,
  git-fuzzy-src,
}:
pkgs.writeShellApplication {
  name = "git-fuzzy";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.git
    pkgs.fzf
  ];

  text = ''
    ${git-fuzzy-src}/bin/git-fuzzy "$@"
  '';
}
