{
  description = "A flake wrapping home.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mlir-nix = {
      url = "github:sabauma/mlir.nix";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-fuzzy-src = {
      url = "github:bigH/git-fuzzy";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      homeConfigurations.spenser = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit (inputs)
            git-fuzzy-src
            mlir-nix
            neorg-overlay
            neovim-nightly
            nixgl
            ;

          user-config.username = "spenser";
        };
      };

      homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit (inputs)
            git-fuzzy-src
            mlir-nix
            neorg-overlay
            neovim-nightly
            nixgl
            ;

          user-config.username = "ubuntu";
        };
      };
    };
}
