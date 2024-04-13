{
  description = "A flake wrapping home.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    mlir-nix.url = "github:sabauma/mlir.nix";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    homeConfigurations.spenser = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nixgl.overlay ];
      };

      modules = [ ./home.nix ];

      extraSpecialArgs = {
        inherit (inputs) neovim-nightly mlir-nix nixgl;
      };
    };
  };
}

