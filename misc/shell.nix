{ pkgs ? import <nixpkgs> {} }:
let
  # Function to create script
  mkScript = pkgs.writeShellScriptBin;

  # Needed to create shell scripts which reference the current directory.
  # We don't want to pull all the related shell scripts into the nix store,
  # particularly bazelw, which inspecs the directory the script is in to figure
  # out where to store things.
  baseDir = toString ./.;

  # The root bazel commands that we will execute.
  bazel = mkScript "bazel" ''${baseDir}/bazelw "$@"'';
  bazelw = mkScript "bazelw" ''${baseDir}/bazelw "$@"'';

  # Execute the bazel command.
  bazelCmd = ''${bazel}/bin/bazel'';

  # Aliases we actually use. Direnv cannot export aliases, so we create a
  # derivation for the relevant aliases, which will be added to $PATH.
  # This is more robust than alises anyway.
  scripts = [
    bazel
    bazelw

    (mkScript "bb" ''${bazelCmd} build "$@"'')
    (mkScript "bd" ''./utils/bazel-debug.sh "$@"'')
    (mkScript "bqg" ''${bazelCmd} query "..." | grep "$@"'')
    (mkScript "br" ''${bazelCmd} run "$@"'')
    (mkScript "bar" ''${bazelCmd} run "$@"'')
    (mkScript "model" ''${bazelCmd} run -- //GenericML/tool/model:modeltool "$@"'')
  ];
in
  pkgs.mkShell {
    name = "modular-dev";

    nativeBuildInputs = [
      pkgs.bazelisk
      pkgs.bazel-watcher
    ] ++ scripts;

    shellHook = ''
      # This will set up the relevant environment variables, but
      # will not be able to export the aliases defined in `aliases.sh` through
      # direnv.
      source ./utils/start-modular.sh
    '';
  }
