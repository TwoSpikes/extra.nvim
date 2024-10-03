if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-notify") == 1 then
	require('packages.vim-notify')
end
require('packages.lsp.plugins')
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-treesitter") == 1 then
	require('packages.treesitter')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/netrw.nvim") == 1 then
	require('packages.netrw')
end
if vim.g.enable_which_key and vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/netrw.nvim") == 1 then
	require('packages.which-key.init')
end
--require('packages.bufresize.init')
require('packages.quickui.init')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/coc.nvim") == 1 then
	if vim.g.use_nvim_cmp then
		vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/coc.nvim", "rf")
		require('packages.nvim-cmp.init')
	else
		require('packages.coc.init')
	end
end
if not vim.g.use_codeium then
	if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/codeium.vim") then
		vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/codeium.vim", "rf")
	end
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/vim-illuminate") == 1 then
	require('packages.vim-illuminate.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/todo-comments.nvim") == 1 then
	require('packages.todo-comments.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/indent-blankline.nvim") == 1 then
	require('packages.indent-blankline.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-dap") == 1 then
	require('packages.dap.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-dap-ui") == 1 then
	require('packages.dapui.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/gitsigns.nvim") == 1 then
	require('packages.gitsigns.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/alpha-nvim") == 1 then
	require('packages.alpha.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/persisted.nvim") == 1 then
	require('packages.persisted.init')
end
--require('packages.lean.init')
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/neogen") == 1 then
	require('packages.neogen.init')
end
if vim.g.compatible ~= "helix" and vim.g.compatible ~= "helix_hard" and vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/yanky.nvim") == 1 then
	require('packages.yanky.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-lint") == 1 then
	require('packages.nvim-lint.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim") == 1 then
	if vim.g.compatible ~= "helix_hard" then
		require('packages.noice.init')
	else
		if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim") then
			vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim", "rf")
		end
	end
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/edgy.nvim") == 1 then
	require('packages.edgy.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/mini.bracketed") == 1 then
	require('packages.mini.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-colorizer.lua") == 1 then
	require('packages.colorizer.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/cinnamon.nvim") == 1 then
	require('packages.cinnamon.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/endscroll.nvim") == 1 then
	require('packages.endscroll.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/none-ls.nvim") == 1 then
	require('packages.null-ls.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/conform.nvim") == 1 then
	require('packages.conform.init')
end
require('packages.convert.init')
if vim.g.enable_nvim_treesitter_context then
	require('packages.treesitter-context.init')
else
	if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-treesitter-context") == 1 then
		vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-treesitter-context", "rf")
	end
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/conform.nvim") == 1 then
	require('packages.ts-autotag.init')
end
require('packages.ufo.init')
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/trouble.nvim") == 1 then
	require('packages.trouble.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/LuaSnip") == 1 then
	require('packages.luasnip.init')
end
require('packages.sneak.init')

-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %CONFIG_PATH%/lua/
-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %LOCALSHAREPATH%/site/pack/packer/start/
