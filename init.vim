call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'terryma/vim-multiple-cursors'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'cohama/lexima.vim'
Plug '907th/vim-auto-save'
Plug 'elixir-editors/vim-elixir'
Plug 'preservim/nerdtree'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
Plug 'dense-analysis/ale'
Plug 'vim-test/vim-test'
call plug#end()
colorscheme gruvbox
set background=dark

set hidden

set number
set relativenumber
set termguicolors

set mouse=a

set inccommand=split

set expandtab
set shiftwidth=2

set clipboard+=unnamedplus

let mapleader="\<space>"
let g:auto_save = 1
let g:auto_save_write_all_buffers = 1
let g:ale_fixers = { 'elixir': ['mix_format'] }

nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader><leader> :Files<cr>
nnoremap <c-f> :Ag<space>
nnoremap <leader><tab> :b<space>

map <leader>f :NERDTreeToggle<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
