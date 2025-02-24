require("packages.bufresize.setup")
vim.cmd('exec printf("so %s/lua/packages/bufresize/autoresize.vim", vim.fn.stdpath("config"))')
