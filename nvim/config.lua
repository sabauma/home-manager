vim.opt.autoindent = true
vim.opt.conceallevel = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2

vim.opt.backspace = "indent,eol,start"
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.formatoptions = "qrn1"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.laststatus = 2
-- vim.opt.lazyredraw = true
vim.opt.modelines = 0
vim.opt.number = true
vim.opt.ruler = true
vim.opt.scrolloff = 3
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.textwidth = 80
vim.opt.title = true
vim.opt.virtualedit = "all"
vim.opt.visualbell = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wrap = true

-- Don't move the cursor to the first column during row traversals
vim.opt.startofline = false

-- Configure diff algorithm to be a little more ergonomic
vim.opt.diffopt:append("algorithm:histogram,indent-heuristic,hiddenoff")

-- Backup & Undo settings
vim.opt.undodir = vim.fn.stdpath("config") .. "/.undo"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/.backup"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

vim.opt.ssop:remove("options") -- do not store global and local values in session
vim.opt.ssop:remove("folds") -- do not store folds in the session

-- CTAGS
vim.opt.tags = "./tags;"

-- List
vim.opt.list = true
vim.opt.listchars = "tab:>-,trail:·,extends:>,precedes:<"

-- Remove menu
-- vim.opt.go='c'

-- Fold based on the syntax of the file, but only fold the outer level
vim.opt.foldnestmax = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Complete options (disable preview scratch window)
vim.opt.completeopt = "menu,menuone,longest"

-- Limit popup menu height
vim.opt.pumheight = 15

vim.opt.statusline = ""
vim.opt.statusline:append("%1*\\ %n\\ %*") -- buffer number
vim.opt.statusline:append("%5*%{&ff}%*") -- file format
vim.opt.statusline:append("%3*%y%*") -- file type
vim.opt.statusline:append("%4*\\ %<%F%*") -- full path
vim.opt.statusline:append("%2*%m%*") -- modified flag
vim.opt.statusline:append("%1*%=%5l%*") -- current line
vim.opt.statusline:append("%2*/%L%*") -- total lines
vim.opt.statusline:append("%1*%6v\\ %*") -- virtual column number
vim.opt.statusline:append("%2*0x%04B\\ %*") -- character under cursor

-- Color Scheme
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 0

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.cmd.colorscheme("gruvbox-material")

function ResolveAndReopen()
  local current_file = vim.fn.expand("%:p")
  local resolved_path = vim.fn.resolve(current_file)

  if current_file ~= resolved_path then
    -- Save the current buffer number
    local current_buf = vim.api.nvim_get_current_buf()

    -- Save the cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Close the old buffer
    vim.api.nvim_buf_delete(current_buf, { force = true })

    vim.cmd("edit " .. vim.fn.fnameescape(resolved_path))

    vim.api.nvim_win_set_cursor(0, cursor_pos)

    print("Reopened file with resolved path: " .. resolved_path)
  else
    print("File path already resolved: " .. current_file)
  end
end

-- Optional: Add a command to call the function
vim.api.nvim_create_user_command("ResolveAndReopen", ResolveAndReopen, {})

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------

-- Navigation of folded lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Invoke telescope's live-grep, find-files, and buffers
vim.keymap.set("n", "<leader>lg", function()
  require("telescope.builtin").live_grep()
end)
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end)
vim.keymap.set("n", "<leader>bb", function()
  require("telescope.builtin").buffers()
end)

-- Press Space to turn off highlighting and clear any message already displayed.
vim.keymap.set("n", "<Space>", "<cmd>nohlsearch<Bar>:echo<CR>", { silent = true })

-- Leader Mappings
-- Quick navigation of tabs
vim.keymap.set("n", "<leader>th", "<cmd>:tabprev<CR>")
vim.keymap.set("n", "<leader>tl", "<cmd>:tabnext<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader>td", "<cmd>:tabclose<CR>")

-- Faster way to switch between splits
vim.keymap.set("n", "<leader>w", "<C-w>w")
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")

-- Use Y to copy until the end of the line. Use yy to copy the whole line.
vim.keymap.set("n", "Y", "y$")

-- Swap the uses of ' and `
vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")

-- Remove trailing whitespace
vim.keymap.set("n", "<leader>s", function()
  local l = vim.fn.line(".")
  local c = vim.fn.col(".")
  vim.cmd([[ %s/\s\+$//e ]])
  vim.fn.cursor(l, c)
end)

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.mlir" },
  callback = function()
    vim.opt.filetype = "mlir"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.h.inc", "*.hpp.inc", "*.cpp.inc" },
  callback = function()
    vim.opt.filetype = "cpp"
  end,
})

-------------------------------------------------------------------------------
-- Plugin Configuration
-------------------------------------------------------------------------------

vim.notify = require("notify")
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

require("pqf").setup({})
require("nvim-surround").setup({})
require("trouble").setup({})

-------------------------------------------------------------------------------
-- LSP Configuration
-------------------------------------------------------------------------------

-- The logs get long very quickly, so disable them
vim.lsp.log.set_level("error")

vim.diagnostic.config({ virtual_lines = true })

local lspconfig = vim.lsp.config

vim.lsp.enable({
  "bash_ls",
  "clangd",
  "cmake",
  "hls",
  "lua_ls",
  "mlir_lsp_server",
  "mojo",
  "nil_ls",
  "nixd",
  "pyright",
  "ruff",
  "tablegen_lsp_server",
})

lspconfig("clangd", {
  cmd = { "clangd", "--completion-style=detailed", "--background-index", "--background-index-priority=low" },
})

lspconfig("lua_ls", {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.env.VIMRUNTIME
        -- },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        library = vim.api.nvim_get_runtime_file("", true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

if vim.env.MODULAR_PATH then
  lspconfig("mlir_lsp_server", {
    cmd = { "modular-lsp-server" },
  })

  local modular_path = vim.env.MODULAR_PATH
  local stdlib = modular_path .. "/open-source/max/mojo/stdlib"
  local max = modular_path .. "/SDK/lib/API/mojo"
  local kernels = modular_path .. "/Kernels/mojo"

  lspconfig("mojo", {
    cmd = {
      "mojo-lsp-server",
      "-I",
      stdlib,
      "-I",
      max,
      "-I",
      kernels,
    },
  })
end

-------------------------------------------------------------------------------
-- Treesitter Configuration
-------------------------------------------------------------------------------

require("nvim-treesitter.configs").setup({
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
  -- Requires nvim-treesitter-refactor
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
  },
})

require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,

      keymaps = {
        -- Built-in captures.
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-------------------------------------------------------------------------------
-- nvim-cmp
-------------------------------------------------------------------------------

-- Setup nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  snippet = {},

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
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<C-x>"] = cmp.mapping(
      cmp.mapping.complete({
        config = {
          sources = cmp.config.sources({
            { name = "cmp_ai" },
          }),
        },
      }),
      { "i" }
    ),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "neorg" },
  }, {
    { name = "buffer" },
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
  }),
})

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------

require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { vertical = { width = 0.7 } },
  },
})

-------------------------------------------------------------------------------
-- Lualine
-------------------------------------------------------------------------------

require("lualine").setup({
  sections = {
    lualine_c = { { "filename", path = 1, shortening_target = 80 } },
  },
})

-------------------------------------------------------------------------------
-- Oil
-------------------------------------------------------------------------------

require("oil").setup()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-------------------------------------------------------------------------------
-- Outline.nvim
-------------------------------------------------------------------------------

require("outline").setup({})

-------------------------------------------------------------------------------
-- gitsigns
-------------------------------------------------------------------------------

require("gitsigns").setup({
  current_line_blame = true,
  trouble = true,
})

-------------------------------------------------------------------------------
-- bigfile.nvim
-------------------------------------------------------------------------------

require("bigfile").setup({
  filesize = 10, -- 10MB file size
})
