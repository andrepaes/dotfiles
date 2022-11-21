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
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
Plug 'vim-test/vim-test'
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-mix-format'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

syntax enable
set background=dark
colorscheme gruvbox
set hidden

if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

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

let g:mix_format_on_save = 0

nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <c-f> :Ag<space>
nnoremap <leader><tab> :b<space>
nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>r <cmd>History<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>

map <leader>f :NERDTreeToggle<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>co  :<C-u>CocList outline<CR>
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
nmap <silent> mf :MixFormat<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

