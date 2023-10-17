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
    use 'neovim/nvim-lspconfig'
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
    use 'rcarriga/nvim-notify'
    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use 'nvim-treesitter/playground'
	use 'weizheheng/nvim-workbench'
	use 'ap/vim-css-color'
	use 'prichrd/netrw.nvim'
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
end)
