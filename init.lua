-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set Default Colorscheme
vim.cmd("colorscheme lunaperche")

-- Set Transparent backgound
-- vim.cmd("highlight Normal guibg=none")
-- vim.cmd("highlight NonText guibg=none")

-- Indentation
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- Remove default statusbar (just use vim-airline)
vim.opt.showmode = false

-- Remap leader key to spacebar
vim.g.mapleader = " "


-- Format current buffer when saving
vim.api.nvim_create_autocmd({ "BufWritePre" }, { command = "lua vim.lsp.buf.format()" })

-- Remap Tab key to switch between tabs in normal mode
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", ":tabclose<CR>", { noremap = true, silent = true })

-- Plugins
require('packer').startup(function(use)
  -- Packer
  use "wbthomason/packer.nvim"
  -- LSP
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig"
  use "neovim/nvim-lspconfig"
  -- Auto completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  -- Status bar
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"
  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } }
  }
  -- Nerdtree
  use "preservim/nerdtree"
  use "Xuyuanp/nerdtree-git-plugin"
  use "ryanoasis/vim-devicons"
  use "tiagofumo/vim-nerdtree-syntax-highlight"
  -- Indentation / Formatting
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }
  -- Which-key
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
end)

-- TELESCOPE CONFIG --
local telescope = require('telescope')

-- Add custom actions to open files in a new tab
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Override the default action for file selection
local custom_actions = {}

custom_actions.open_in_tab = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  vim.cmd('tabnew ' .. selection.path)
end

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        -- Map enter key to open file in new tab
        ["<CR>"] = custom_actions.open_in_tab,
      },
    }
  }
}

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", telescope.find_files, {})



--  Set Airline Theme
vim.g.airline_theme = "simple"

-- LSP CONFIGURATION
local servers = { "clangd", "lua_ls" }

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = servers
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
end

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- setup each lsp server in servers
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

-- NvimCMP setup (autocompletion)
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-o>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- NERDTREE
vim.keymap.set("n", "§", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_create_autocmd({ "TabLeave" }, { command = ":NERDTreeClose" })
