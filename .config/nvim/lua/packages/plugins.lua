require('lib.lists.contains')
require('lib.lists.compare')

function patch_plugin(pluginname)
	local path = vim.fn.expand('~/.config/nvim/patch/')..pluginname
	if vim.fn.isdirectory(path) == 1 then
		local patches = vim.fn.readdir(path)
		for i, patch in ipairs(patches) do
			vim.cmd("silent !cd>/dev/null;patch -p0 -r - < ~/.config/nvim/patch/"..pluginname..'/'..patch..';cd ->/dev/null')
		end
	else
		local patch_name = pluginname..'.patch'
		vim.cmd("silent !cd>/dev/null;patch -p0 -r - < ~/.config/nvim/patch/"..patch_name..';cd ->/dev/null')
	end
end

function unpatch_plugin(pluginname)
	local path = vim.fn.expand('~/.config/nvim/patch/')..pluginname
	if vim.fn.isdirectory(path) == 1 then
		local patches = vim.fn.readdir(path)
		for i, patch in ipairs(patches) do
			vim.cmd("silent !cd>/dev/null;patch -p0 -R -r - < ~/.config/nvim/patch/"..pluginname..'/'..patch..';cd ->/dev/null')
		end
	else
		local patch_name = pluginname..'.patch'
		vim.cmd("silent !cd>/dev/null;patch -p0 -R -r - < ~/.config/nvim/patch/"..patch_name..";cd ->/dev/null")
	end
end

local function bootstrap_lazy()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    vim.fn.system({
      'git',
      'clone',
	  '--depth=1',
      "--filter=blob:none",
      'https://github.com/folke/lazy.nvim.git',
      lazy_path
    })
  end

  patch_plugin('lazy.nvim')

  vim.opt.rtp:prepend(lazy_path)
end

bootstrap_lazy();

local lazy = require('lazy');

local plugins = {
	{
		'folke/lazy.nvim',
		patch = function()
			patch_plugin('lazy.nvim')
		end,
		unpatch = function()
			unpatch_plugin('lazy.nvim')
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
	},
	{
        'williamboman/mason.nvim',
	},
	{
        'williamboman/mason-lspconfig.nvim',
	},
	{
		'neovim/nvim-lspconfig',
	},
	{
        'RishabhRD/lspactions',
        branch = 'master',
        dependencies = {
            {
                'nvim-lua/popup.nvim',
                dependencies = {
                    'nvim-lua/plenary.nvim',
                },
            },
        },
	},
	{
		'rcarriga/nvim-notify',
	},
	{
		'nvim-treesitter/nvim-treesitter',
		patch = function()
			patch_plugin('nvim-treesitter')
		end,
		unpatch = function()
			unpatch_plugin('nvim-treesitter')
		end,
	},
	{
		'nvim-treesitter/playground',
	},
	{
		'weizheheng/nvim-workbench',
	},
	{
		'norcalli/nvim-colorizer.lua',
	},
	{
		'prichrd/netrw.nvim',
	},
	{
		"folke/which-key.nvim",
	},
	{
		"kwkarlwang/bufresize.nvim",
	},
	{
		'junegunn/goyo.vim',
	},
	{
		'junegunn/limelight.vim',
	},
	{
		'rust-lang/rust.vim',
	},
	{
		'preservim/tagbar',
	},
	{
		'skywind3000/vim-quickui',
		patch = function()
			patch_plugin('vim-quickui')
		end,
		unpatch = function()
			unpatch_plugin('vim-quickui')
		end,
	},
	{
		'neoclide/coc.nvim',
		branch = 'master',
		build = 'npm ci',
		enabled = not vim.g.use_nvim_cmp,
	},
	{
		'neoclide/vim-jsx-improve',
	},
	{
		'voldikss/vim-floaterm',
	},
	{
		'https://github.com/vim-utils/vim-man',
	},
	{
		'tpope/vim-surround',
	},
	{
		'alvan/vim-closetag',
	},
	{
		'yuezk/vim-js',
	},
	{
		'maxmellon/vim-jsx-pretty',
	},
	{
		'kmoschcau/emmet-vim',
	},
	{
		'github/copilot.vim',
		enabled = vim.g.use_github_copilot,
	},
	{
		'erietz/vim-terminator',
	},
	{
		'tpope/vim-fugitive',
	},
	{
		'mg979/vim-visual-multi',
		branch = 'master',
	},
	{
		'vim-jp/vital.vim',
	},
	{
		'nvim-pack/nvim-spectre',
		dependencies = {
			'nvim-lua/plenary.nvim',
		}
	},
	{
		'RRethy/vim-illuminate',
		patch = function()
			patch_plugin('vim-illuminate')
		end,
		unpatch = function()
			unpatch_plugin('vim-illuminate')
		end,
	},
	{
		'folke/todo-comments.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		}
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				"nvim-neotest/nvim-nio",
			}
		}
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			},
		}
	},
	{
		'nvim-telescope/telescope-dap.nvim',
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			},
		}
	},
	{
		'mfussenegger/nvim-dap-python',
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	},
	{
		'leoluz/nvim-dap-go',
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	},
	{
		'mfussenegger/nvim-jdtls',
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	},
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.on_attach = function(client, bufnr)
				-- your on_attach function
			end

			return metals_config
		end,
		config = function(self, metals_config)
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end
	},
	{
		'hrsh7th/cmp-nvim-lsp',
	},
	{
		'hrsh7th/cmp-buffer',
	},
	{
		'hrsh7th/cmp-path',
	},
	{
		'hrsh7th/cmp-cmdline',
	},
	{
		'hrsh7th/nvim-cmp',
	},
	{
		'hrsh7th/cmp-vsnip',
	},
	{
		'hrsh7th/vim-vsnip',
	},
	{
		'lewis6991/gitsigns.nvim',
	},
	{
		'goolord/alpha-nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		},
	},
	{
		'olimorris/persisted.nvim',
	},
	{
		'Julian/lean.nvim',
		event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-lua/plenary.nvim',
		},

		opts = {
			lsp = {
				on_attach = on_attach,
			},
			mappings = true,
		}
	},
	{
		'tommcdo/vim-lion',
	},
	{
		'lyokha/vim-xkbswitch',
		enabled = os.getenv('TERMUX_VERSION') == nil,
	};
	{
		"danymat/neogen",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	},
	{
		'https://github.com/folke/yanky.nvim',
	},
	{
		'https://github.com/mfussenegger/nvim-lint',
	},
	{
		'smartpde/telescope-recent-files',
	},
	{
		'https://github.com/folke/noice.nvim',
		dependencies = {
			{
				'MunifTanjim/nui.nvim',
			},
			{
				'rcarriga/nvim-notify',
			},
		},
		enabled = vim.fn.match(vim.g.compatible, '^helix_hard') == -1,
	};
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
	},
	{
		'echasnovski/mini.bracketed',
	},
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v3.x",
		dependencies = { 
		  "nvim-lua/plenary.nvim",
		  "MunifTanjim/nui.nvim",
-- 		  "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
	{
		'TwoSpikes/endscroll.nvim',
	},
	{
		'declancm/cinnamon.nvim',
	},
	{
		'nvimtools/none-ls.nvim',
		dependencies = {
			'nvimtools/none-ls-extras.nvim',
		}
	},
	{
		'stevearc/conform.nvim',
	},
	{
		'cjodo/convert.nvim',
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		enabled = vim.g.enable_nvim_treesitter_context,
	},
	{
		'windwp/nvim-ts-autotag',
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = {
			'kevinhwang91/promise-async',
		}
	},
	{
		'sindrets/diffview.nvim',
	},
	{
		'folke/trouble.nvim',
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},
	{
		'justinmk/vim-sneak',
	},
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		dependencies = {
			{
				'junegunn/fzf',
				build = function()
					vim.fn.system('install')
				end,
			},
		},
	},
	{
		'Exafunction/codeium.vim',
		enabled = vim.g.use_codeium,
	},
	{
		'TwoSpikes/music-player.vim',
	},
	{
		'airblade/vim-gitgutter',
		enabled = vim.fn.match(vim.g.compatible, '^helix') == -1,
	},
	{
		'danilamihailov/beacon.nvim',
	},
	{
		'm-demare/hlargs.nvim',
	},
	{
		'RaafatTurki/hex.nvim',
	},
	{
		'TwoSpikes/pkgman.nvim',
	},
	{
		'TwoSpikes/ani-cli.nvim',
	},
	{
		'TwoSpikes/hlchunk.nvim',
	},
	{
		'jinzhongjia/LspUI.nvim',
	},
	{
		'Thiago4532/mdmath.nvim',
		enabled = vim.fn.has('gui_running'),
		dependencies = {
			{
				'nvim-treesitter/nvim-treesitter',
				patch = function()
					patch_plugin('nvim-treesitter')
				end,
				unpatch = function()
					unpatch_plugin('nvim-treesitter')
				end,
			},
		},
	},
	{
		'https://github.com/roobert/activate.nvim',
	},
	{
		'abecodes/tabout.nvim',
		config = function()
            require('tabout').setup {
                tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<C-d>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = true, -- if the tabkey is used in a completion pum
                tabouts = {
                    {open = "'", close = "'"},
                    {open = '"', close = '"'},
                    {open = '`', close = '`'},
                    {open = '(', close = ')'},
                    {open = '[', close = ']'},
                    {open = '{', close = '}'}
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {} -- tabout will ignore these filetypes
            }
        end,
	},
	{
		'https://github.com/dstein64/nvim-scrollview',
		enabled = vim.g.enable_scrollview,
	},
};

lazy.setup({
	spec = plugins,
	install = {
		colorscheme = { "blueorange" }
	},
	checker = {
		enabled = false,
	},
})
