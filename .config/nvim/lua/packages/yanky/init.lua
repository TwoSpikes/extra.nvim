require('packages.yanky.setup')
vim.cmd([[exec printf("so %s", g:CONFIG_PATH.'/lua/packages/yanky/keymaps.vim')]])
