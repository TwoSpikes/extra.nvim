vim.cmd([[exec printf("so %s", g:CONFIG_PATH.'/lua/packages/luasnip/keymaps.vim')]])
require('packages.luasnip.setup')
