require('nvim-treesitter').setup()
require('nvim-treesitter.install').prefer_git = true

require('nvim-treesitter.install').commands.TSUpdate.run()
