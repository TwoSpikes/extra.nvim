require('packages.vim-notify')
require('packages.lsp.plugins')
require('packages.treesitter')
require('packages.netrw')
require('packages.which-key.init')
--require('packages.bufresize.init')
require('packages.quickui.init')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
if vim.g.use_nvim_cmp then
	require('packages.nvim-cmp.init')
else
	require('packages.coc.init')
end
require('packages.vim-illuminate.init')
require('packages.todo-comments.init')
require('packages.indent-blankline.init')
require('packages.dap.init')
require('packages.dapui.init')
require('packages.gitsigns.init')
require('packages.alpha.init')
require('packages.persisted.init')
--require('packages.lean.init')
require('packages.neogen.init')
require('packages.flash-nvim.init')
require('packages.yanky.init')
require('packages.nvim-lint.init')
require('packages.noice.init')
require('packages.edgy.init')
require('packages.mini.init')
require('packages.colorizer.init')
--require('packages.endscroll.init')
require('packages.cinnamon.init')
require('packages.null-ls.init')
require('packages.conform.init')
