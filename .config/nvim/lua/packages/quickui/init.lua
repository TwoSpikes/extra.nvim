vim.cmd('exec printf("so %s/lua/packages/quickui/setup.vim", stdpath("config"))')
require('packages.quickui.menu.init')
