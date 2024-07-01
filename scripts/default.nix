{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "my-shell-scripts";

  src = ./.;

  propagatedBuildInputs = with pkgs; [
    bash
    fzf
    git
    gnugrep
    xdg-utils
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/* $out/bin/
    chmod +x $out/bin/*
    patchShebangs $out/bin
  '';
}
