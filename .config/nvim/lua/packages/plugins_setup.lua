require('lib.vim.plugins')

if plugin_installed("nvim-notify") then
	require('packages.vim-notify')
end
require('packages.lsp.plugins')
if plugin_installed("nvim-treesitter") then
	require('packages.treesitter')
end
if plugin_installed("netrw.nvim") then
	require('packages.netrw')
end
if vim.g.enable_which_key and plugin_installed("which-key.nvim") then
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
if plugin_installed("vim-illuminate") then
	require('packages.vim-illuminate.init')
end
if plugin_installed("todo-comments.nvim") then
	require('packages.todo-comments.init')
end
if plugin_installed("indent-blankline.nvim") then
	require('packages.indent-blankline.init')
end
if plugin_installed("nvim-dap") then
	require('packages.dap.init')
end
if plugin_installed("nvim-dap-ui") then
	require('packages.dapui.init')
end
if plugin_installed("gitsigns.nvim") then
	require('packages.gitsigns.init')
end
if plugin_installed("alpha-nvim") then
	require('packages.alpha.init')
end
if plugin_installed("persisted.nvim") then
	require('packages.persisted.init')
end
--require('packages.lean.init')
if plugin_installed("neogen") then
	require('packages.neogen.init')
end
if vim.g.compatible ~= "helix" and vim.g.compatible ~= "helix_hard" and plugin_installed("yanky.nvim") then
	require('packages.yanky.init')
end
if plugin_installed("nvim-lint") then
	require('packages.nvim-lint.init')
end
if plugin_installed("noice.nvim") then
	if vim.g.compatible ~= "helix_hard" then
		require('packages.noice.init')
	else
		if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim") then
			vim.fn.delete(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/noice.nvim", "rf")
		end
	end
end
if plugin_installed("edgy.nvim") then
	require('packages.edgy.init')
end
if plugin_installed("mini.bracketed") then
	require('packages.mini.init')
end
if plugin_installed("nvim-colorizer.lua") then
	require('packages.colorizer.init')
end
if plugin_installed("cinnamon.nvim") and not vim.g.disable_cinnamon then
	require('packages.cinnamon.init')
end
if plugin_installed("endscroll.nvim") then
	require('packages.endscroll.init')
end
if plugin_installed("none-ls.nvim") then
	require('packages.null-ls.init')
end
if plugin_installed("conform.nvim") then
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
if plugin_installed("nvim-ts-autotag") then
	require('packages.ts-autotag.init')
end
if plugin_installed("nvim-ufo") then
	require('packages.ufo.init')
end
if plugin_installed("trouble.nvim") then
	require('packages.trouble.init')
end
if plugin_installed("LuaSnip") then
	require('packages.luasnip.init')
end
if plugin_installed("vim-sneak") then
	require('packages.sneak.init')
end
if plugin_installed("hlargs.nvim") then
	require('packages.hlargs.init')
end

-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %CONFIG_PATH%/lua/
-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %LOCALSHAREPATH%/site/pack/packer/start/
