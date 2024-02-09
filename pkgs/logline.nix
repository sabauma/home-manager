{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScriptBin "logline" ''
  while IFS= read -r line;
  do
    echo -e "\033[0;34m$(date '+%Y-%m-%d %H:%M:%S')\033[0m\t $line"
  done
''
