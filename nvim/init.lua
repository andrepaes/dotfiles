local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug('morhetz/gruvbox')
Plug('terryma/vim-multiple-cursors')
Plug('sheerun/vim-polyglot')
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug('junegunn/fzf.vim')
Plug('cohama/lexima.vim')
Plug('907th/vim-auto-save')
Plug('elixir-editors/vim-elixir')
Plug('preservim/nerdtree')
Plug('Xuyuanp/nerdtree-git-plugin')
Plug('xolox/vim-misc')
Plug('xolox/vim-session')
Plug('neovim/nvim-lspconfig')
Plug('vim-test/vim-test')
Plug('tpope/vim-fugitive')
Plug('mhinz/vim-mix-format')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})
Plug('elixir-tools/elixir-tools.nvim')
Plug('mhanberg/output-panel.nvim')
vim.call('plug#end')

local sets = vim.opt

vim.g.syntax = true
sets.background="dark"
vim.cmd.colorscheme('gruvbox')

sets.hidden=true

sets.number=true
sets.relativenumber=true
sets.termguicolors=true
vim.cmd([[set clipboard+=unnamedplus]])
vim.cmd([[set relativenumber]])

sets.mouse=a

sets.inccommand=split

sets.expandtab=true
sets.shiftwidth=2

vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

vim.g.mapleader=" "
vim.g.auto_save = true
vim.g.auto_save_write_all_buffers = true

vim.g.mix_format_on_save = 0

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

local elixirls_old = vim.fn.expand("~/Downloads/elixir-ls-1.12-23.3/language_server.sh")
local elixir = require("elixir")
local elixir_ls = vim.env.ELIXIR_LS

local function setup_elixirls(elixir_lsp)
  if elixir_lsp == "elixirls" and elixir_ls == "newest" then
    return {
      repo = "elixir-lsp/elixir-ls",
      branch = "master",
      settings = elixir.elixirls.settings {
        dialyzerEnabled = false,
        enableTestLenses = false,
      },
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      on_attach = function()
        vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
      end
    }
  elseif elixir_lsp == "elixirls" then
    return {
      cmd = elixirls_old,
      settings = elixir.elixirls.settings {
        dialyzerEnabled = false,
        enableTestLenses = false,
      },
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      on_attach = function()
        vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
      end
    }
  else
    return {enable = false}
  end
end

require("elixir").setup({
  nextls = {enable = vim.env.ELIXIR_LSP == "nextls"},
  credo = {enable = false},
  elixirls = setup_elixirls(vim.env.ELIXIR_LSP),
})
require("output_panel").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function()
    vim.keymap.set("n", "<s-k>", vim.lsp.buf.hover, { buffer = true, noremap = true })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, noremap = true })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true, noremap = true })
    vim.keymap.set("n", "mf", vim.lsp.buf.format, { buffer = true, noremap = true })
    vim.keymap.set("n", "<leader>o", ":OutputPanel<cr>", { buffer = true, noremap = true })
  end
})

vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<cr>", { noremap = true })
vim.keymap.set("n", "<c-f>", ":Ag<space>", { noremap = true })
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>r", "<cmd>History<cr>", { noremap = true })
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":NERDTreeToggle<CR>", { noremap = false })
vim.keymap.set("n", "qp", vim.cmd.cprev, { desc = "Go to the previous item in the quickfix list." })
vim.keymap.set("n", "qn", vim.cmd.cnext, { desc = "Go to the next item in the quickfix list." })
vim.keymap.set("n", "qq", vim.cmd.ccl, { desc = "Close quickfix list" })
vim.keymap.set("n", "tn", vim.cmd.TestNearest, { desc = "Run nearest test" })
vim.keymap.set("n", "tf", vim.cmd.TestFile, { desc = "Run test file" })
vim.keymap.set("n", "ts", vim.cmd.TestSuite, { desc = "Run test suite" })
vim.keymap.set("n", "tl", vim.cmd.TestLast, { desc = "Run last test" })
