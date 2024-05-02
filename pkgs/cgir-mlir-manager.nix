{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "CGIR-MLIR Manager";

  src = ./cgir_mlir_manager;

  buildInputs = [
    pkgs.bash
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r scripts/ $out/
    cp -r shortcuts/ $out/

    for file in $out/shortcuts/*
    do
      filename=$(basename -- "$file")
      ln -s $out/shortcuts/$filename $out/bin/$filename
    done

    ln -s $out/scripts/cgir-mlir-manager-sourced $out/bin/cgir-mlir-manager
  '';
}
