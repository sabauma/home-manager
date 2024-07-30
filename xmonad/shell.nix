{
  pkgs ? import <nixpkgs> { },
}:
let
  haskellEnv = pkgs.haskellPackages.ghcWithPackages (
    ps: with ps; [
      hashable

      text
      text-icu

      xmonad
      xmonad-contrib
      xmonad-extras
      vector
    ]
  );
in
pkgs.mkShell { packages = [ haskellEnv ]; }
