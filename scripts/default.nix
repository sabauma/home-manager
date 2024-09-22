{
  pkgs,
}:

let
  wrapShellScript =
    name:
    pkgs.writeShellApplication {
      inherit name;

      runtimeInputs = with pkgs; [
        bash
        coreutils
        curl
        fzf
        git
        skim
      ];

      text = builtins.readFile ./${name};
  };

in

pkgs.buildEnv {
  name = "scripts";
  paths = [
    (wrapShellScript "gbr")
    (wrapShellScript "git-commit-show")
    (wrapShellScript "git-fuzzy-diff")
    (wrapShellScript "git-fuzzy-log")
    (wrapShellScript "githist")
    (wrapShellScript "ilog")
  ];
}
