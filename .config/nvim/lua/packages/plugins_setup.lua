require('packages.vim-notify')
require('packages.lsp.plugins')
require('packages.treesitter')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
