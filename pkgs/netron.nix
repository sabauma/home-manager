{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [ tensorflow ]);

in
  pkgs.writeShellScriptBin "netron" ''
    ${pythonEnv}/bin/python3 -m tensorflow.lite.tools.visualize $1 $2
  ''
