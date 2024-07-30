
vim.opt.autoindent=true
vim.opt.conceallevel=0
vim.opt.expandtab=true
vim.opt.shiftwidth=2
vim.opt.smartindent=true
vim.opt.tabstop=2

vim.opt.backspace='indent,eol,start'
vim.opt.colorcolumn='80'
vim.opt.cursorline=true
vim.opt.encoding='utf-8'
vim.opt.formatoptions='qrn1'
vim.opt.hidden=true
vim.opt.hlsearch=true
vim.opt.ignorecase=true
vim.opt.inccommand='nosplit'
vim.opt.incsearch=true
vim.opt.laststatus=2
vim.opt.lazyredraw=true
vim.opt.modelines=0
vim.opt.number=true
vim.opt.ruler=true
vim.opt.scrolloff=3
vim.opt.showcmd=true
vim.opt.showmode=true
vim.opt.smartcase=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.textwidth=80
vim.opt.title=true
vim.opt.virtualedit='all'
vim.opt.visualbell=true
vim.opt.wildmenu=true
vim.opt.wildmode='list:longest'
vim.opt.wrap=true

-- Don't move the cursor to the first column during row traversals
vim.opt.startofline=false

-- Configure diff algorithm to be a little more ergonomic
vim.opt.diffopt:append('algorithm:histogram,indent-heuristic,hiddenoff')

-- Backup & Undo settings
vim.opt.undodir=vim.fn.stdpath('config') .. '/.undo' 
vim.opt.backupdir=vim.fn.stdpath('config') .. '/.backup'
vim.opt.undofile=true
vim.opt.undolevels=1000
vim.opt.undoreload=10000

vim.opt.ssop:remove('options')   -- do not store global and local values in session
vim.opt.ssop:remove('folds')     -- do not store folds in the session

-- CTAGS
vim.opt.tags='./tags;'

-- List
vim.opt.list=true
vim.opt.listchars='tab:>-,trail:·,extends:>,precedes:<'

-- Remove menu
-- vim.opt.go='c'

-- Fold based on the syntax of the file, but only fold the outer level
vim.opt.foldnestmax=1
vim.opt.foldmethod='expr'
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldenable=false

-- Complete options (disable preview scratch window)
vim.opt.completeopt='menu,menuone,longest'

-- Limit popup menu height
vim.opt.pumheight=15

vim.opt.statusline=""
vim.opt.statusline:append('%1*\\ %n\\ %*')   -- buffer number
vim.opt.statusline:append('%5*%{&ff}%*')     -- file format
vim.opt.statusline:append('%3*%y%*')         -- file type
vim.opt.statusline:append('%4*\\ %<%F%*')    -- full path
vim.opt.statusline:append('%2*%m%*')         -- modified flag
vim.opt.statusline:append('%1*%=%5l%*')      -- current line
vim.opt.statusline:append('%2*/%L%*')        -- total lines
vim.opt.statusline:append('%1*%6v\\ %*')     -- virtual column number
vim.opt.statusline:append('%2*0x%04B\\ %*')  -- character under cursor


-- Color Scheme
vim.g.gruvbox_material_foreground='original'
vim.g.gruvbox_material_background='hard'
vim.g.gruvbox_material_background='hard'
vim.g.gruvbox_material_disable_italic_comment=1
vim.g.gruvbox_material_enable_bold=1
vim.g.gruvbox_material_enable_italic=0


vim.opt.background='dark'
vim.opt.termguicolors = true
vim.cmd.colorscheme("gruvbox-material")

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------

-- Navigation of folded lines
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Invoke telescope's live-grep and find-files
vim.keymap.set('n', '<leader>lg', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end)

-- Press Space to turn off highlighting and clear any message already displayed.
vim.keymap.set('n', '<Space>', '<cmd>nohlsearch<Bar>:echo<CR>', {silent = true})

-- Leader Mappings
-- Quick navigation of tabs
vim.keymap.set('n', '<leader>th', '<cmd>:tabprev<CR>')
vim.keymap.set('n', '<leader>tl', '<cmd>:tabnext<CR>')
vim.keymap.set('n', '<leader>tn', '<cmd>:tabnew<CR>')
vim.keymap.set('n', '<leader>td', '<cmd>:tabclose<CR>')

-- Faster way to switch between splits
vim.keymap.set('n', '<leader>w', '<C-w>w')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<leader>l', '<C-w>l')

-- Use Y to copy until the end of the line. Use yy to copy the whole line.
vim.keymap.set('n', 'Y', 'y$')

-- Swap the uses of ' and `
vim.keymap.set('n', "'", "`")
vim.keymap.set('n', "`", "'")

-- Remove trailing whitespace
vim.keymap.set('n', '<leader>s', function()
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')
  vim.cmd [[ %s/\s\+$//e ]]
  vim.fn.cursor(l, c)
end)

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {"*.mlir"},
  callback = function()
    vim.opt.filetype = 'mlir'
  end,
})

-------------------------------------------------------------------------------
-- Plugin Configuration
-------------------------------------------------------------------------------

vim.notify = require('notify')

require('pqf').setup {}
require('nvim-surround').setup {}
require('trouble').setup {}

-------------------------------------------------------------------------------
-- LSP Configuration
-------------------------------------------------------------------------------

local goto_prev = function(opts)
  vim.diagnostic.jump({count=-1, float=true})
end

local goto_next = function(opts)
  vim.diagnostic.jump({count=1, float=true})
end

-- Mappings.
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '[g', goto_prev, bufopts)
  vim.keymap.set('n', ']g', goto_next, bufopts)

  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

local lspconfig = require('lspconfig')

lspconfig.bashls.setup {
  on_attach = on_attach,
}

lspconfig.clangd.setup {
  cmd = {"clangd", "--completion-style=detailed", "--background-index", "--background-index-priority=low"},
  on_attach = on_attach,
}

lspconfig.cmake.setup {
  on_attach = on_attach,
}

lspconfig.hls.setup {
  on_attach = on_attach,
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.env.VIMRUNTIME
        -- },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

lspconfig.mlir_lsp_server.setup {
  on_attach = on_attach,
}

lspconfig.mojo.setup {
  on_attach = on_attach,
}

lspconfig.nil_ls.setup {
  on_attach = on_attach,
}

lspconfig.pyright.setup {
  on_attach = on_attach,
}

lspconfig.tblgen_lsp_server.setup {
  on_attach = on_attach,
}

-------------------------------------------------------------------------------
-- Treesitter Configuration
-------------------------------------------------------------------------------

require('nvim-treesitter.configs').setup {
  -- Grammars are managed by nix
  -- ensure_installed = "all",
  -- ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-------------------------------------------------------------------------------
-- Neorg
-------------------------------------------------------------------------------

require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.concealer"] = {
      config = {
        markup = {
          enabled = true
        },
        icon_preset = "basic"
      }
    }, -- Allows for use of icons
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp" -- We current support nvim-compe and nvim-cmp only
      }
    },
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode"
      },
    },
    ["core.dirman"] = {
      config = {
        workspaces = {
          work = "~/Notes/work",
          personal = "~/Notes/personal"
        }
      }
    },
    ["core.integrations.telescope"] = {}, -- Enable the telescope module
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = "<Leader>o" -- This is the default if unspecified
      }
    },
    ["core.qol.toc"] = { },
    ["core.export"] = { },
    ["core.export.markdown"] = {
      config = {
        extensions = "all",
      }
    },
    ["core.journal"] = {
      config = {
        journal_folder = "journal",
        strategy = "flat"
      }
    },
    ["core.esupports.metagen"] = {
      config = {
        type = "auto",
        tab = "  ",
        update_date = true
      }
    },
  },
}

-------------------------------------------------------------------------------
-- nvim-cmp
-------------------------------------------------------------------------------

-- Setup nvim-cmp.
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup {
  snippet = { },

  window = {
    completion = cmp.config.window.bordered({
      -- border = "shadow"
    }),

    documentation = cmp.config.window.bordered({
      -- border = "shadow"
    }),
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
    }),
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'neorg'    },
  }, {
    { name = 'buffer' },
  })
}

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } }
    })
})

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------

require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { vertical = { width = 0.7 } },
  },
}

require('telescope').load_extension('fzf')

-------------------------------------------------------------------------------
-- Lualine
-------------------------------------------------------------------------------

require("lualine").setup {
  sections = {
    lualine_c = {{ 'filename', path = 1, shortening_target=80 }}
  },
}

-------------------------------------------------------------------------------
-- Oil
-------------------------------------------------------------------------------

require("oil").setup()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-------------------------------------------------------------------------------
-- Outline.nvim
-------------------------------------------------------------------------------

require("outline").setup {}

