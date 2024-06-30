require('packages.vim-notify')
require('packages.lsp.plugins')
require('packages.treesitter')
require('packages.netrw')
if vim.g.enable_which_key then
	require('packages.which-key.init')
end
--require('packages.bufresize.init')
require('packages.quickui.init')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
if vim.g.use_nvim_cmp then
	if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/coc.nvim") then
		vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/coc.nvim", "rf")
	end
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
if vim.g.compatible ~= "helix_hard" then
	require('packages.noice.init')
else
	if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim") then
		vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim", "rf")
	end
end
require('packages.edgy.init')
require('packages.mini.init')
require('packages.colorizer.init')
require('packages.cinnamon.init')
require('packages.endscroll.init')
require('packages.null-ls.init')
require('packages.conform.init')
require('packages.convert.init')
require('packages.treesitter-context.init')
require('packages.ts-autotag.init')
require('packages.ufo.init')
require('packages.trouble.init')
require('packages.luasnip.init')

-- DotfilesOptionInComment LUA_REQUIRE_GOTO_PREFIX [g:CONFIG_PATH.'/lua/', g:LOCALSHAREPATH.'/site/pack/packer/start/']
