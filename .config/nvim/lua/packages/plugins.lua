vim.cmd('packadd packer.nvim')

return require('packer').startup(function (use)
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
        },
    }
    use {
        'williamboman/mason.nvim',
    }
    use {
        'williamboman/mason-lspconfig.nvim',
    }
    use {
		'neovim/nvim-lspconfig',
	}
    use {
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
    }
	use {
		'rcarriga/nvim-notify',
	}
    use (
		'nvim-treesitter/nvim-treesitter',
		{run = ':TSUpdate'}
	)
    use {
		'nvim-treesitter/playground',
	}
	use {
		'weizheheng/nvim-workbench',
	}
	use {
		'norcalli/nvim-colorizer.lua',
	}
	use {
		'prichrd/netrw.nvim',
	}
	use {
		"windwp/nvim-autopairs",
	-- 	config = function() require("nvim-autopairs").setup {} end
	}
	use {
		"folke/which-key.nvim",
	}
	use {
		"kwkarlwang/bufresize.nvim",
	}
	use {
		'junegunn/goyo.vim',
	}
	use {
		'junegunn/limelight.vim',
	}
	use {
		'rust-lang/rust.vim',
	}
	use {
		'preservim/tagbar',
	}
	use {
		'ryanoasis/vim-devicons',
	}
	use {
		'skywind3000/vim-quickui',
	}
	if not vim.g.use_nvim_cmp then
		use {
			'neoclide/coc.nvim',
			branch = 'release',
		}
	end
	use {
		'neoclide/vim-jsx-improve',
	}
	use {
		'voldikss/vim-floaterm',
	}
	use {
		'https://github.com/vim-utils/vim-man',
	}
	use {
		'tpope/vim-surround',
	}
	use {
		'alvan/vim-closetag',
	}
	use {
		'yuezk/vim-js',
	}
	use {
		'maxmellon/vim-jsx-pretty',
	}
	use {
		'mattn/emmet-vim',
	}
	if not vim.g.use_github_copilot == false then
		use {
			'github/copilot.vim',
		}
	end
	use {
		'erietz/vim-terminator',
	}
	use {
		'tpope/vim-fugitive',
	}
	use {
		'mg979/vim-visual-multi',
		branch = 'master',
	}
	use {
		'vim-jp/vital.vim',
	}
	use {
		'nvim-pack/nvim-spectre',
		requires = {
			'nvim-lua/plenary.nvim',
		}
	}
	use {
		'RRethy/vim-illuminate',
	}
	use {
		'folke/todo-comments.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
		}
	}
	use {
		'lukas-reineke/indent-blankline.nvim',
	}

	use {
		"rcarriga/nvim-dap-ui",
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				"nvim-neotest/nvim-nio",
			}
		}
	}
	use {
		"theHamsta/nvim-dap-virtual-text",
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				'nvim-treesitter/nvim-treesitter',
				{run = ':TSUpdate'}
			}
		}
	}
	use {
		'nvim-telescope/telescope-dap.nvim',
		requires = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				'nvim-telescope/telescope.nvim',
				requires = {
					{ 'nvim-lua/plenary.nvim' },
				},
			}
		}
	}
	use {
		'mfussenegger/nvim-dap-python',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	}
	use {
		'leoluz/nvim-dap-go',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	}
	use {
		'mfussenegger/nvim-jdtls',
		requires = {
			{
				"mfussenegger/nvim-dap",
			}
		}
	}
	use {
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
		ft = { "scala", "sbt", "java" },
		opts = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to either "off" or "on"
      --
      -- "off" will enable LSP progress notifications by Metals and you'll need
      -- to ensure you have a plugin like fidget.nvim installed to handle them.
      --
      -- "on" will enable the custom Metals status extension and you *have* to have
      -- a have settings to capture this in your statusline or else you'll not see
      -- any messages from metals. There is more info in the help docs about this
      metals_config.init_options.statusBarProvider = "off"

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        -- LSP mappings
        map("n", "gD", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gi", vim.lsp.buf.implementation)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "gds", vim.lsp.buf.document_symbol)
        map("n", "gws", vim.lsp.buf.workspace_symbol)
        map("n", "<leader>cl", vim.lsp.codelens.run)
        map("n", "<leader>sh", vim.lsp.buf.signature_help)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "<leader>f", vim.lsp.buf.format)
        map("n", "<leader>ca", vim.lsp.buf.code_action)

        map("n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end)

        -- all workspace diagnostics
        map("n", "<leader>aa", vim.diagnostic.setqflist)

        -- all workspace errors
        map("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        map("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        map("n", "<leader>d", vim.diagnostic.setloclist)

        map("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        map("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)

        -- Example mappings for usage with nvim-dap. If you don't use that, you can
        -- skip these
        map("n", "<leader>dc", function()
          require("dap").continue()
        end)

        map("n", "<leader>dr", function()
          require("dap").repl.toggle()
        end)

        map("n", "<leader>dK", function()
          require("dap.ui.widgets").hover()
        end)

        map("n", "<leader>dt", function()
          require("dap").toggle_breakpoint()
        end)

        map("n", "<leader>dso", function()
          require("dap").step_over()
        end)

        map("n", "<leader>dsi", function()
          require("dap").step_into()
        end)

        map("n", "<leader>dl", function()
          require("dap").run_last()
        end)
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
	}

	use {
		'hrsh7th/cmp-nvim-lsp',
	}
	use {
		'hrsh7th/cmp-buffer',
	}
	use {
		'hrsh7th/cmp-path',
	}
	use {
		'hrsh7th/cmp-cmdline',
	}
	use {
		'hrsh7th/nvim-cmp',
	}
	use {
		'hrsh7th/cmp-vsnip',
	}
	use {
		'hrsh7th/vim-vsnip',
	}
	use {
		'lewis6991/gitsigns.nvim',
	}
	use {
		'goolord/alpha-nvim',
	}
	use {
		'olimorris/persisted.nvim',
	}
	use {
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
	}
	 use {
		 'tommcdo/vim-lion',
	 }
	if os.getenv('TERMUX_VERSION') == nil then
		use {
			'lyokha/vim-xkbswitch',
		}
	end
	use {
		"danymat/neogen",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	}
	use {
		'https://github.com/folke/yanky.nvim',
	}
	use {
		'https://github.com/mfussenegger/nvim-lint',
	}
	use {
		'smartpde/telescope-recent-files',
		requires = {
			{
				'nvim-telescope/telescope.nvim',
			}
		}
	}
	if vim.g.compatible ~= "helix_hard" then
		use {
			'https://github.com/folke/noice.nvim',
			requires = {
				{
					'MunifTanjim/nui.nvim',
				},
				{
					'rcarriga/nvim-notify',
				},
			}
		}
	end
	use {
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
	}
	use {
		'echasnovski/mini.bracketed',
	}
	use {
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v3.x",
		requires = { 
		  "nvim-lua/plenary.nvim",
		  "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		  "MunifTanjim/nui.nvim",
		  "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	}
	use {
		'TwoSpikes/endscroll.nvim',
	}
	use {
		'declancm/cinnamon.nvim',
	}
	use {
		'nvimtools/none-ls.nvim',
		requires = {
			'nvimtools/none-ls-extras.nvim',
		}
	}
	use {
		'stevearc/conform.nvim',
	}
	use {
		'cjodo/convert.nvim',
	}
	if vim.g.enable_nvim_treesitter_context then
		use {
			'nvim-treesitter/nvim-treesitter-context',
		}
	end
	use {
		'windwp/nvim-ts-autotag',
	}
	use {
		'kevinhwang91/nvim-ufo',
		requires = {
			'kevinhwang91/promise-async',
		}
	}
	use {
		'sindrets/diffview.nvim',
	}
	use {
		'folke/trouble.nvim',
	}
	use({
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
	})
	use {
		'justinmk/vim-sneak',
	}
	use {
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		requires = {
			{
				'junegunn/fzf',
				run = function()
					vim.fn['fzf#install']()
				end,
			},
			{
				'nvim-treesitter/nvim-treesitter',
				run = ':TSUpdate',
			},
		},
	}
	if vim.g.use_codeium then
		use {
			'Exafunction/codeium.vim',
		}
	end
	use {
		'TwoSpikes/music-player.vim',
	}
	if vim.g.compatible ~= "helix" and vim.g.compatible ~= "helix_hard" then
		use {
			'airblade/vim-gitgutter',
		}
	end
	use {
		'm-demare/hlargs.nvim',
	}
end)
