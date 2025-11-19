require('packages.nvim-lint.setup')
vim.cmd[[exec printf('so %s', g:CONFIG_PATH.'/lua/packages/nvim-lint/autocmds.vim')]]
