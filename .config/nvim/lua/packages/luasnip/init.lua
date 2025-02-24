vim.cmd([[exec printf("so %s", stdpath('config').'/lua/packages/luasnip/keymaps.vim')]])
require('packages.luasnip.setup')
