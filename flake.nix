{
  description = "A flake wrapping home.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    mlir-nix.url = "github:sabauma/mlir.nix";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, neovim-nightly, mlir-nix, ... }@inputs:
  {
    homeConfigurations.spenser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];

      extraSpecialArgs = {
        inherit (inputs) neovim-nightly mlir-nix;
      };
    };
  };
}

