require('packages.yanky.setup')
vim.cmd([[exec printf("so %s", stdpath('config').'/lua/packages/yanky/keymaps.vim')]])
