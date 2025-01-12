require('lib.lists.contains')
require('lib.lists.compare')

local function patch_plugin(pluginname)
	local patch_name
	if vim.fn.isdirectory(vim.fn.expand('~/.config/nvim/patch/')..pluginname) == 1 then
		patch_name = pluginname..'/*.patch'
	else
		patch_name = pluginname..'.patch'
	end
	vim.cmd("!cd>/dev/null;patch -p0 < ~/.config/nvim/patch/"..patch_name..';cd ->/dev/null')
end

local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
	  '--depth=1',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })

	local dirs = vim.fn.readdir(vim.fn.expand('~/.config/nvim/patch/pckr.nvim'))
	for i, dir in ipairs(dirs) do
		vim.cmd('!cd>/dev/null;patch -p0 < ~/.config/nvim/patch/pckr.nvim/'..dir..';cd ->/dev/null')
	end
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr();

local pckr = require('pckr')

pckr.add({
	{
		'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
        },
		run = function()
			patch_plugin('telescope.nvim')
		end,
    };
    {
        'williamboman/mason.nvim',
    };
    {
        'williamboman/mason-lspconfig.nvim',
    };
    {
		'neovim/nvim-lspconfig',
	};
    {
        'RishabhRD/lspactions',
        branch = 'master',
        requires = {
            {
                'nvim-lua/popup.nvim',
                requires = {
                    'nvim-lua/plenary.nvim',
                },
            },
        },
    };
	{
		'rcarriga/nvim-notify',
	};
    {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
	};
    {
		'nvim-treesitter/playground',
	};
	{
		'weizheheng/nvim-workbench',
	};
	{
		'norcalli/nvim-colorizer.lua',
	};
	{
		'prichrd/netrw.nvim',
	};
	{
		"windwp/nvim-autopairs",
	-- 	config = function() require("nvim-autopairs").setup {} end
	};
	{
		"folke/which-key.nvim",
	};
	{
		"kwkarlwang/bufresize.nvim",
	};
	{
		'junegunn/goyo.vim',
	};
	{
		'junegunn/limelight.vim',
	};
	{
		'rust-lang/rust.vim',
	};
	{
		'preservim/tagbar',
	};
	{
		'skywind3000/vim-quickui',
	};
});
if not vim.g.use_nvim_cmp then
	pckr.add({
		{
			'neoclide/coc.nvim',
			branch = 'master',
			run = 'npm ci',
		}
	});
end
pckr.add({
	{
		'neoclide/vim-jsx-improve',
	};
	{
		'voldikss/vim-floaterm',
	};
	{
		'https://github.com/vim-utils/vim-man',
	};
	{
		'tpope/vim-surround',
	};
	{
		'alvan/vim-closetag',
	};
	{
		'yuezk/vim-js',
	};
	{
		'maxmellon/vim-jsx-pretty',
	};
	{
		'kmoschcau/emmet-vim',
	};
});
if not vim.g.use_github_copilot == false then
	pckr.add({
		{
			'github/copilot.vim',
		}
	});
end
pckr.add({
	{
		'erietz/vim-terminator',
	};
	{
		'tpope/vim-fugitive',
	};
	{
		'mg979/vim-visual-multi',
		branch = 'master',
	};
	{
		'vim-jp/vital.vim',
	};
	{
		'nvim-pack/nvim-spectre',
		requires = {
			'nvim-lua/plenary.nvim',
		}
	};
	{
		'RRethy/vim-illuminate',
	};
	{
		'folke/todo-comments.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
		}
	};
	{
		'lukas-reineke/indent-blankline.nvim',
	};

	{
		"rcarriga/nvim-dap-ui",
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				"nvim-neotest/nvim-nio",
			}
		}
	};
	{
		"theHamsta/nvim-dap-virtual-text",
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
		}
	};
	{
		'nvim-telescope/telescope-dap.nvim',
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
		}
	};
	{
		'mfussenegger/nvim-dap-python',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	};
	{
		'leoluz/nvim-dap-go',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	};
	{
		'mfussenegger/nvim-jdtls',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	};
	{
		'scalameta/nvim-metals',
		requires = {
			{
				'nvim-lua/plenary.nvim'
			},
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			{
				"mfussenegger/nvim-dap",
			}
		},
    config = 'packages.metals.init'
	};
	{
		'hrsh7th/cmp-nvim-lsp',
	};
	{
		'hrsh7th/cmp-buffer',
		run = function()
			patch_plugin('cmp-buffer')
		end,
	};
	{
		'hrsh7th/cmp-path',
		run = function()
			patch_plugin('cmp-path')
		end,
	};
	{
		'hrsh7th/cmp-cmdline',
		run = function()
			patch_plugin('cmp-cmdline')
		end,
	};
	{
		'hrsh7th/nvim-cmp',
	};
	{
		'hrsh7th/cmp-vsnip',
	};
	{
		'hrsh7th/vim-vsnip',
	};
	{
		'lewis6991/gitsigns.nvim',
	};
	{
		'goolord/alpha-nvim',
	};
	{
		'olimorris/persisted.nvim',
	};
	{
		'Julian/lean.nvim',
		event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

		requires = {
			'neovim/nvim-lspconfig',
			'nvim-lua/plenary.nvim',
		},

		opts = {
			lsp = {
				on_attach = on_attach,
			},
			mappings = true,
		}
	};
	{
		'tommcdo/vim-lion',
	};
})
if os.getenv('TERMUX_VERSION') == nil then
	pckr.add({
		'lyokha/vim-xkbswitch',
	});
end
pckr.add({
	{
		"danymat/neogen",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	};
	{
		'https://github.com/folke/yanky.nvim',
	};
	{
		'https://github.com/mfussenegger/nvim-lint',
	};
	{
		'smartpde/telescope-recent-files',
	};
});
if vim.fn.match(vim.g.compatible, "^helix_hard") == -1 then
	pckr.add({
		'https://github.com/folke/noice.nvim',
		requires = {
			{
				'MunifTanjim/nui.nvim',
			},
			{
				'rcarriga/nvim-notify',
			},
		}
	});
end
pckr.add({
	{
		'https://github.com/folke/edgy.nvim',
		opts = {
			bottom = {
			  -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
			  {
				ft = "toggleterm",
				size = { height = 0.4 },
				-- exclude floating windows
				filter = function(buf, win)
				  return vim.api.nvim_win_get_config(win).relative == ""
				end,
			  },
			  {
				ft = "lazyterm",
				title = "LazyTerm",
				size = { height = 0.4 },
				filter = function(buf)
				  return not vim.b[buf].lazyterm_cmd
				end,
			  },
			  "Trouble",
			  { ft = "qf", title = "QuickFix" },
			  {
				ft = "help",
				size = { height = 20 },
				-- only show help buffers
				filter = function(buf)
				  return vim.bo[buf].buftype == "help"
				end,
			  },
			  { ft = "spectre_panel", size = { height = 0.4 } },
			},
			left = {
			  -- Neo-tree filesystem always takes half the screen height
			  {
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
				  return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.5 },
			  },
			  {
				title = "Neo-Tree Git",
				ft = "neo-tree",
				filter = function(buf)
				  return vim.b[buf].neo_tree_source == "git_status"
				end,
				pinned = true,
				open = "Neotree position=right git_status",
			  },
			  {
				title = "Neo-Tree Buffers",
				ft = "neo-tree",
				filter = function(buf)
				  return vim.b[buf].neo_tree_source == "buffers"
				end,
				pinned = true,
				open = "Neotree position=top buffers",
			  },
			  {
				ft = "Outline",
				pinned = true,
				open = "SymbolsOutlineOpen",
			  },
			  -- any other neo-tree windows
			  "neo-tree",
			},
		},
	};
	{
		'echasnovski/mini.bracketed',
	};
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v3.x",
		requires = { 
		  "nvim-lua/plenary.nvim",
		  "MunifTanjim/nui.nvim",
		  "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	};
	{
		'TwoSpikes/endscroll.nvim',
	};
	{
		'declancm/cinnamon.nvim',
	};
	{
		'nvimtools/none-ls.nvim',
		requires = {
			'nvimtools/none-ls-extras.nvim',
		}
	};
	{
		'stevearc/conform.nvim',
	};
	{
		'cjodo/convert.nvim',
	};
});
if vim.g.enable_nvim_treesitter_context then
	pckr.add({
		'nvim-treesitter/nvim-treesitter-context',
	});
end
pckr.add({
	{
		'windwp/nvim-ts-autotag',
	};
	{
		'kevinhwang91/nvim-ufo',
		requires = {
			'kevinhwang91/promise-async',
		}
	};
	{
		'sindrets/diffview.nvim',
	};
	{
		'folke/trouble.nvim',
	};
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!:).
		run = "make install_jsregexp",
		requires = {
			{
				'rafamadriz/friendly-snippets',
			}
		},
	};
	{
		'justinmk/vim-sneak',
	};
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		requires = {
			{
				'junegunn/fzf',
				run = function()
					vim.fn['fzf#install']()
				end,
			},
		},
	};
});
if vim.g.use_codeium then
	pckr.add({
		'Exafunction/codeium.vim',
	});
end
pckr.add({
	{
		'TwoSpikes/music-player.vim',
	};
});
if vim.fn.match(vim.g.compatible, '^helix') == -1 then
	pckr.add({
		'airblade/vim-gitgutter',
	});
end
pckr.add({
	{
		'm-demare/hlargs.nvim',
	};
	{
		'danilamihailov/beacon.nvim',
	};
	{
		'RaafatTurki/hex.nvim',
	};
	{
		'TwoSpikes/pkgman.nvim',
	};
	{
		'TwoSpikes/ani-cli.nvim',
	};
});

