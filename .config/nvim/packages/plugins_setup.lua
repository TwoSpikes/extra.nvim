require('packages.vim-notify')
require('packages.lsp.plugins')
require('packages.treesitter')
require('packages.netrw')
require('packages.which-key.init')
--require('packages.bufresize.init')
require('packages.quickui.init')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
require('packages.coc.init')
