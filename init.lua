-- Remaps

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Back dir
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format() end)
vim.keymap.set("n", "<C-d>", ":q<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")


-- Options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

-- Packer

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', branch = '0.1.x', requires = { { 'nvim-lua/plenary.nvim' } } }
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		}
	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
	}
	use "EdenEast/nightfox.nvim"
	use({
		"utilyre/barbecue.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"smiteshp/nvim-navic",
		},
		config = function()
			require("barbecue").setup()
		end,
	})
	use 'echasnovski/mini.nvim'
	use 'beauwilliams/statusline.lua'
	use 'yamatsum/nvim-cursorline'
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	use 'preservim/nerdcommenter'
	use "numToStr/FTerm.nvim"
	use 'lewis6991/gitsigns.nvim'
end)

-- Theme

vim.cmd("colorscheme nightfox")

-- Telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-o>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- Treesitter

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "rust", "python", "julia", "zig" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}


-- Undotree

vim.keymap.set("n", "<C-u>", vim.cmd.UndotreeToggle)


-- Fugitive

vim.keymap.set("n", "<C-g>", vim.cmd.Git)

-- LSP

local lsp = require('lsp-zero')
lsp.preset('recommended')

local cmp = require('cmp')
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	if client.name == "eslint" then
		vim.cmd.LspStop('eslint')
		return
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.set_preferences({ sign_icons = {} })

lsp.setup()

-- NVIM tree

vim.keymap.set("n", "<C-b>", vim.cmd.NvimTreeToggle)
require("nvim-tree").setup({
	sort_by = "case_insensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	renderer = {
		group_empty = true,
	},
})

-- Mini

require('mini.starter').setup()

-- Statusline

local statusline = require('statusline')
statusline.tabline = false


-- Cursorline

require('nvim-cursorline').setup {
	cursorline = {
		enable = true,
		timeout = 1000,
		number = false,
	},
	cursorword = {
		enable = true,
		min_length = 3,
		hl = { underline = true },
	}
}

-- NERDCommenter

vim.keymap.set("n", "<C-_>", vim.cmd.NERDCommenterToggle)
vim.keymap.set("v", "<C-_>", vim.cmd.NERDCommenterToggle)


-- Terminal

require 'FTerm'.setup({
	border     = 'double',
	dimensions = {
		height = 0.9,
		width = 0.9,
	},
})
vim.keymap.set('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')


-- Gitsigns

require('gitsigns').setup {
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}
