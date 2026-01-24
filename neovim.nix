{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Needed for haskell-language-server
    ghc

    # Language Servers
    basedpyright
    bash-language-server
    cmake-language-server
    haskell-language-server
    lua-language-server
    nil
    nixd
    pyright
    ruff
    shellcheck

    # Contains the clangd language server
    llvmPackages_latest.clang-tools
    llvmPackages_latest.mlir
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;

    initLua = builtins.readFile ./nvim/config.lua;

    # Manage treesitter parsers through nix to avoid issues with libc
    plugins = with pkgs.vimPlugins; [
      # Vim Plugins
      a-vim
      nerdcommenter
      tabular
      undotree
      vim-fugitive
      vim-indent-object
      vim-obsession
      vim-repeat

      nvim-surround

      # bigfile.nvim
      bigfile-nvim

      # Treesitter

      # Disable due to version conflict
      # nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars

      # Colorschemes
      gruvbox-material
      everforest

      # Quickfix list plugins
      nvim-bqf
      nvim-pqf

      # Neovim-notify
      nvim-notify
      noice-nvim
      snacks-nvim

      # nvim-cmp
      nvim-cmp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path

      # LSP
      clangd_extensions-nvim
      dressing-nvim
      lspkind-nvim
      nvim-lspconfig

      # Git Related
      gitsigns-nvim

      # Lualine
      lualine-nvim

      # Telescope
      telescope-nvim
      # telescope-fzf-native-nvim

      # Nice popup messages
      popup-nvim

      # Oil file manager
      oil-nvim

      # outline.nvim
      outline-nvim

      # Trouble.nvim
      trouble-nvim
      nvim-web-devicons
    ];
  };
}
