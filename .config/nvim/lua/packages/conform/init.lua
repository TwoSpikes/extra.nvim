require('packages.conform.setup')
vim.cmd([[exec printf("so %s", g:CONFIG_PATH.'/lua/packages/conform/keymaps.vim')]])
