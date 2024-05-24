{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;

    extraConfig = builtins.readFile ./nvim/init.vim;
    extraLuaConfig = builtins.readFile ./nvim/config.lua;

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
      vim-colors-solarized
      vim-surround
      vim-vinegar

      # Treesitter
      nvim-treesitter.withAllGrammars

      # Colorschemes
      gruvbox-material
      everforest

      nvim-bqf

      # Neovim-notify
      nvim-notify

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

      # Lualine
      lualine-nvim

      # Telescope
      telescope-nvim
      telescope-fzf-native-nvim

      # Neorg
      # neorg
      # neorg-telescope
      zen-mode-nvim

      # Obsidian notes
      obsidian-nvim

      # Nice popup messages
      popup-nvim

      # Oil file manager
      oil-nvim

      # outline.nvim
      outline-nvim
    ];
  };
}
