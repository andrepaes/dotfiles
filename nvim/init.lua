_G.motch = {}
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug('ellisonleao/gruvbox.nvim')
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
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate'], ['tag'] = 'v0.9.1'})
Plug('elixir-tools/elixir-tools.nvim')
Plug('mhanberg/output-panel.nvim')
Plug('christoomey/vim-tmux-navigator')
Plug('christoomey/vim-tmux-runner')
Plug('lewis6991/gitsigns.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('folke/noice.nvim')
Plug('MunifTanjim/nui.nvim')
Plug('echasnovski/mini.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('elixir-editors/vim-elixir')
Plug('rcarriga/nvim-notify')
Plug('jedrzejboczar/possession.nvim')
Plug('hrsh7th/nvim-cmp')
vim.call('plug#end')

local sets = vim.opt

vim.g.syntax = false
sets.background="light"
vim.cmd.colorscheme('gruvbox')

sets.hidden=true

sets.number=true
sets.relativenumber=true
sets.termguicolors=true
vim.cmd([[set relativenumber]])

local vim_notify_notfier = function(cmd, exit)
  if exit == 0 then
    vim.notify("Success: " .. cmd, vim.log.levels.INFO)
  else
    vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
  end
end

vim.g.motch_term_auto_close = true

vim.g["test#custom_strategies"] = {
  motch = function(cmd)
    local winnr = vim.fn.winnr()
    require("motch.term").open(cmd, winnr, vim_notify_notfier)
  end,
}
vim.g["test#strategy"] = "motch"

sets.mouse=a

sets.inccommand=split

sets.expandtab=true
sets.shiftwidth=2

vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

vim.g.mapleader=" "
vim.g.auto_save = false
vim.g.auto_save_write_all_buffers = true

vim.g.mix_format_on_save = 0

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup {
  highlighters = {
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

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

require('nvim-treesitter.configs').setup({
  ensure_installed = {"elixir", "heex", "eex"}, -- only install parsers for elixir and heex
  sync_install = false,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
})

require('telescope').setup{
  pickers = {
    find_files = {
      theme = "ivy"
    },
    live_grep = {
      theme = "ivy"
    },
    git_files = {
      theme = "ivy"
    },
    lsp_document_symbols = {
      theme = "ivy"
    }
  }
}

vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<cr>", { noremap = true })
vim.keymap.set("n", "<c-f>", ":Ag<space>", { noremap = true })
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>r", "<cmd>History<cr>", { noremap = true })
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", "<leader>F", "<cmd>Telescope git_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>co", "<cmd>Telescope lsp_document_symbols<cr>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":NERDTreeToggle<CR>", { noremap = false })
vim.keymap.set("n", "<c-t>", ":tabnew<CR>", { noremap = false })
vim.keymap.set("n", "<leader>1", "1gt", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>2", "2gt", { noremap = true })
vim.keymap.set("n", "<leader>3", "3gt", { noremap = true })
vim.keymap.set("n", "<leader>4", "4gt", { noremap = true })
vim.keymap.set("n", "<leader>5", "5gt", { noremap = true })
vim.keymap.set("n", "<leader>6", "6gt", { noremap = true })
vim.keymap.set("n", "<leader>7", "7gt", { noremap = true })
vim.keymap.set("n", "<leader>8", "8gt", { noremap = true })
vim.keymap.set("n", "<leader>9", "9gt", { noremap = true })
vim.keymap.set("n", "<leader>0", "0gt", { noremap = true })
vim.keymap.set("n", "<leader>s", ":Telescope possession list<cr>", { noremap = true })
vim.keymap.set("n", "mF", ":MixFormat<cr>", { noremap = true })
vim.keymap.set("n", "qp", vim.cmd.cprev, { desc = "Go to the previous item in the quickfix list." })
vim.keymap.set("n", "qn", vim.cmd.cnext, { desc = "Go to the next item in the quickfix list." })
vim.keymap.set("n", "qq", vim.cmd.ccl, { desc = "Close quickfix list" })
vim.keymap.set("n", "tn", vim.cmd.TestNearest, { desc = "Run nearest test" })
vim.keymap.set("n", "tf", vim.cmd.TestFile, { desc = "Run test file" })
vim.keymap.set("n", "ts", vim.cmd.TestSuite, { desc = "Run test suite" })
vim.keymap.set("n", "tl", vim.cmd.TestLast, { desc = "Run last test" })

vim.cmd[[
  function! ElixirUmbrellaTransform(cmd) abort
    if match(a:cmd, 'apps/') != -1
      return substitute(a:cmd, 'mix test apps/\([^/]*\)/', 'doppler run -- mix cmd --app \1 mix test --color ', '')
    else
      return a:cmd
    end
  endfunction

  let g:test#custom_transformations = {'elixir_umbrella': function('ElixirUmbrellaTransform')}
  let g:test#transformation = 'elixir_umbrella'
]]

require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
        -- map("n", "<leader>hS", gs.stage_buffer)
        -- map("n", "<leader>hu", gs.undo_stage_hunk)
        -- map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hp", gs.preview_hunk)
        -- map("n", "<leader>hb", function()
        --   gs.blame_line { full = true }
        -- end)
        -- map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>hd", gs.diffthis)
         map("n", "<leader>hD", function()
           gs.diffthis("~")
         end)
        -- map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end
}
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
        lualine_a = { session_name },
        lualine_c = { { "filename", path = 1}},
        lualine_x = { "selectioncount", "searchcount", "encoding", "fileformat", "filetype" }
  },

  extensions = {"fzf"}
}

require("noice").setup({
      cmdline = {
        enabled = true, -- disable if you use native command line UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {
          buf_options = { filetype = "vim" },
          border = {
            style = { " ", " ", " ", " ", " ", " ", " ", " " },
          },
        }, -- enable syntax highlighting in the cmdline
        icons = {
          ["/"] = { icon = " " },
          ["?"] = { icon = " " },
          [":"] = { icon = ":", firstc = false },
        },
      },
      messages = {
        backend = "mini",
      },
      notify = {
        backend = "mini",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        message = {
          view = "mini",
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 1,
            col = "50%",
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = { find = "Scanning" },
          opts = { skip = true },
        },
      },
    })
  require("cmp").setup(
    {
        event = "InsertEnter",
        init = function()
          vim.opt.completeopt = { "menu", "menuone", "noselect" }
        end,
        config = function()
          local cmp = require("cmp")

          cmp.setup {
            snippet = {
              expand = function(args)
                -- For `vsnip` user.
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert {
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.close(),
              ["<C-y>"] = cmp.mapping.confirm { select = true },
            },
            sources = {
              { name = "nvim_lsp" },
              { name = "vsnip" },
              { name = "vim-dadbod-completion" },
              { name = "spell", keyword_length = 5 },
              -- { name = "rg", keyword_length = 3 },
              -- { name = "buffer", keyword_length = 5 },
              -- { name = "emoji" },
              { name = "path" },
              { name = "git" },
            },
            formatting = {
              format = require("lspkind").cmp_format {
                with_text = true,
                menu = {
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  -- emoji = "[Emoji]",
                  spell = "[Spell]",
                  path = "[Path]",
                  cmdline = "[Cmd]",
                },
              },
            },
          }

          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 2 } }),
          })
        -- Set up lspconfig.
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
          require('lspconfig')['elixir_ls'].setup {
            capabilities = capabilities
          }
        end,
        dependencies = {
          { "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
          "f3fora/cmp-spell",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-emoji",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip",

          "onsails/lspkind-nvim",
          {
            "petertriho/cmp-git",
            config = function()
              require("cmp_git").setup()
            end,
            dependencies = { "nvim-lua/plenary.nvim" },
          },
        },
      }
    )

