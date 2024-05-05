
lua << EOF
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
vim.opt.undodir='~/.nvim/undodir//'
vim.opt.backupdir='~/.nvim/backup//'
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


vim.opt.background=dark
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

EOF

