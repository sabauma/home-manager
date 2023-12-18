
" Tab settings
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set conceallevel=0

set termguicolors

let g:gruvbox_material_foreground='original'
let g:gruvbox_material_background='hard'
let g:gruvbox_material_background='hard'
let g:gruvbox_material_disable_italic_comment=1
let g:gruvbox_material_enable_bold=1
let g:gruvbox_material_enable_italic=0

set background=dark
colorscheme gruvbox-material

" Search options
set hlsearch
set incsearch
set ignorecase
set smartcase
set inccommand=nosplit

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set virtualedit=all

set modelines=0
set wrap
set textwidth=90
set formatoptions=qrn1
set colorcolumn=90
set title
set lazyredraw
set splitright
set splitbelow

" Don't move the cursor to the first column during row traversals
set nostartofline

" Configure diff algorithm to be a little more ergonomic
set diffopt+=algorithm:histogram,indent-heuristic,hiddenoff

" Backup & Undo settings
set undodir=~/.nvim/undodir//
set backupdir=~/.nvim/backup//
set undofile
set undolevels=1000
set undoreload=10000

set ssop-=options   " do not store global and local values in session
set ssop-=folds     " do not store folds in the session

" Navigation of folded lines
map j gj
map k gk

" Fold based on the syntax of the file, but only fold the outer level
set foldnestmax=1
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
nnoremap ' `
nnoremap ` '

" Remove menu
set go=c

" Leader Mappings
" Quick navigation of tabs
map <leader>th :tabprev<CR>
map <leader>tl :tabnext<CR>
map <leader>tn :tabnew<CR>
map <leader>td :tabclose<CR>

" Faster way to switch between splits
map <leader>w <C-w>w
map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l

" Remove trailing whitespace
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

map <silent> <leader>s :call StripTrailingWhitespaces() <CR>

" Invoke telescope's live-grep
map <silent> <leader>lg :lua require('telescope.builtin').live_grep() <CR>
map <silent> <leader>ff :lua require('telescope.builtin').find_files() <CR>

" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest

" Limit popup menu height
set pumheight=15

" Key Maps
" --------
" Use Y to copy until the end of the line. Use yy to copy the whole line.
nnoremap Y y$

set statusline=
set statusline +=%1*\ %n\ %*            " buffer number
set statusline +=%5*%{&ff}%*            " file format
set statusline +=%3*%y%*                " file type
set statusline +=%4*\ %<%F%*            " full path
set statusline +=%2*%m%*                " modified flag
set statusline +=%1*%=%5l%*             " current line
set statusline +=%2*/%L%*               " total lines
set statusline +=%1*%6v\ %*             " virtual column number
set statusline +=%2*0x%04B\ %*          " character under cursor

set list
set listchars=tab:>-,trail:·,extends:>,precedes:<

" Interrobangs...
digraph !? 8253
digraph ?! 8253

" CTAGS
set tags=./tags;

" Set filetype for mlir files
autocmd BufNewFile,BufRead *.mlir set filetype=mlir

