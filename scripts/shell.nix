with import <nixpkgs> {};

mkShell {
  buildInputs = [
    (import ./default.nix {})
  ];
}
