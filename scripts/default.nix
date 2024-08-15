{
  pkgs,
}:

let
  wrapShellScript =
    { name }:
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
    (wrapShellScript { name = "gbr"; })
    (wrapShellScript { name = "git-commit-show"; })
    (wrapShellScript { name = "git-fuzzy-diff"; })
    (wrapShellScript { name = "git-fuzzy-log"; })
    (wrapShellScript { name = "ilog"; })
  ];
}
