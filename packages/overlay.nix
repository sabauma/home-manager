final: prev: {
  magic = prev.callPackage ./magic.nix {};
  mojo = prev.callPackage ./mojo.nix {};
}
