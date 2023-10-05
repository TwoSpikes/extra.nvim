vim.cmd [[ packadd packer.nvim ]]

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
end)
