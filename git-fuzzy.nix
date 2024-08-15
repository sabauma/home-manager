{
  pkgs,
  git-fuzzy,
}:
pkgs.writeShellApplication {
  name = "git-fuzzy";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.git
    pkgs.fzf
  ];

  text = ''
    ${git-fuzzy}/bin/git-fuzzy "$@"
  '';
}
