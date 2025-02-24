require('packages.nvim-lint.setup')
vim.cmd[[exec printf('so %s', stdpath('config').'/lua/packages/nvim-lint/autocmds.vim')]]
