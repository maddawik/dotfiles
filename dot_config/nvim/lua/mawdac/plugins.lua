local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- List of Plugins
return packer.startup(function(use)
  -- Must-haves
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "kyazdani42/nvim-web-devicons" -- File icons (required by many plugins)

  -- More features
  use { "nvim-neo-tree/neo-tree.nvim", requires = { "MunifTanjim/nui.nvim" } } -- Filetree
  use "akinsho/toggleterm.nvim" -- Terminal manager
  use "ahmedkhalf/project.nvim" -- Project manager
  use "akinsho/bufferline.nvim" -- Bufferline
  use "nvim-lualine/lualine.nvim" -- Statusline
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
  use "goolord/alpha-nvim" -- Sexy dashboard
  use "folke/which-key.nvim" -- Whichkey to use
  use "folke/noice.nvim" -- UI for messages, cmdline, and popupmenu
  use "mbbill/undotree" -- Undo tree
  use {
    "simrat39/symbols-outline.nvim", -- Symbol outline
    config = function() require('symbols-outline').setup() end
  }

  -- "Developer Experience"
  use "mrjones2014/smart-splits.nvim" -- Tmux-like and actual tmux nav
  use "windwp/nvim-autopairs" -- Auto-pair braces
  use {
    "numToStr/Comment.nvim", -- Comments
    config = function() require('Comment').setup() end
  }
  use "max397574/better-escape.nvim" -- Quicker exiting normal mode for `jk`
  use "lewis6991/impatient.nvim" -- Faster lua loading
  use "Darazaki/indent-o-matic" -- Fast indentation detection
  use "famiu/bufdelete.nvim" -- Better buffer delete command

  -- Colorschemes
  use "catppuccin/nvim" -- Catppuccin
  use "folke/tokyonight.nvim" -- Tokyonight baby
  use "rebelot/kanagawa.nvim" -- Smooth scrolling

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- Completion
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-emoji" -- emoji completions
  use "chrisgrieser/cmp-nerdfont" -- nerdfont icon completions

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "blankname/vim-fish"

  -- Keep this at the end
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
