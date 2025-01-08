require('lib.vim.plugins')

if plugin_installed("notify") then
	require('packages.vim-notify')
end
require('packages.lsp.plugins')
if plugin_installed("nvim-treesitter") then
	require('packages.treesitter')
end
if plugin_installed("netrw") then
	require('packages.netrw')
end
if vim.g.enable_which_key and plugin_installed("which-key") then
	require('packages.which-key.init')
end
--require('packages.bufresize.init')
require('packages.quickui.init')
vim.cmd('exec printf("so %s/lua/packages/mason.vim", g:CONFIG_PATH)')
if plugin_exists('coc.nvim') then
	if vim.g.use_nvim_cmp then
		plugin_delete('coc.nvim')
		require('packages.nvim-cmp.init')
	else
		require('packages.coc.init')
	end
end
if not vim.g.use_codeium then
	if plugin_exists('codeium.vim') then
		plugin_delete('codeium.vim')
	end
end
if plugin_installed("illuminate") then
	require('packages.vim-illuminate.init')
end
if plugin_installed("todo-comments") then
	require('packages.todo-comments.init')
end
if plugin_installed("ibl") then
	require('packages.indent-blankline.init')
end
if plugin_installed("dap-python") or plugin_installed("dap-go") then
	require('packages.dap.init')
end
if plugin_installed("dapui") then
	require('packages.dapui.init')
end
if plugin_installed("gitsigns") then
	require('packages.gitsigns.init')
end
if plugin_installed("alpha") then
	require('packages.alpha.init')
end
if plugin_installed("persisted") then
	require('packages.persisted.init')
end
--require('packages.lean.init')
if plugin_installed("neogen") then
	require('packages.neogen.init')
end
if vim.fn.match(vim.g.compatible, "^helix") == -1 and plugin_installed("yanky") then
	require('packages.yanky.init')
end
if plugin_installed("lint") then
	require('packages.nvim-lint.init')
end
if plugin_installed("noice") then
	if vim.fn.match(vim.g.compatible, "^helix_hard") == -1 then
		require('packages.noice.init')
	else
		if plugin_exists('noice.nvim') then
			plugin_delete('noice.nvim')
		end
	end
end
if plugin_installed("edgy") then
	require('packages.edgy.init')
end
if plugin_installed("mini.bracketed") then
	require('packages.mini.init')
end
if plugin_installed("colorizer") then
	require('packages.colorizer.init')
end
if plugin_installed("cinnamon") and not vim.g.disable_cinnamon then
	require('packages.cinnamon.init')
end
if plugin_installed("endscroll") then
	require('packages.endscroll.init')
end
if plugin_installed("null-ls") then
	require('packages.null-ls.init')
end
if plugin_installed("conform") then
	require('packages.conform.init')
end
require('packages.convert.init')
if vim.g.enable_nvim_treesitter_context then
	require('packages.treesitter-context.init')
else
	if plugin_exists('nvim-treesitter-context') then
		plugin_delete('nvim-treesitter-context')
	end
end
if plugin_installed("nvim-ts-autotag") then
	require('packages.ts-autotag.init')
end
if plugin_installed("ufo") then
	require('packages.ufo.init')
end
if plugin_installed("trouble") then
	require('packages.trouble.init')
end
if plugin_installed("luasnip") then
	require('packages.luasnip.init')
end
if plugin_exists("vim-sneak") then
	require('packages.sneak.init')
end
if plugin_installed("hlargs") then
	require('packages.hlargs.init')
end
if plugin_installed("beacon") then
	require('packages.beacon.init')
end
if plugin_installed("hex") then
	require('packages.hex.init')
end

-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %CONFIG_PATH%/lua/%FILE%.lua
-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %LOCALSHAREPATH%/site/pack/pckr/opt/*/lua/%FILE%.lua
-- ExNvimOptionInComment LUA_REQUIRE_GOTO_PREFIX %LOCALSHAREPATH%/site/pack/pckr/opt/*/lua/%FILE%/init.lua
