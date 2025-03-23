require('lib.lists.concat')

if vim.g.language == 'russian' then
	new_file_label = 'Новый файл'
	find_file_label = 'Найти файл'
	load_last_session_label = 'Открыть предыдущую сессию'
	open_terminal_label = 'Открыть терминал'
	recently_opened_files_label = 'Предыдущие открытые файлы'
	open_nerdtree_label = 'Открыть Neo-tree.nvim'
	open_ranger_label = 'Открыть ranger'
	update_plugins_label = 'Обновить плагины с помощью vim-plug'
	quit_neovim_label = 'Выйти из NeoVim'
else
	new_file_label = 'New file'
	find_file_label = 'Find file'
	load_last_session_label = 'Load last session'
	open_terminal_label = 'Open Terminal'
	recently_opened_files_label = 'Recently opened files'
	open_nerdtree_label = 'Open Neo-tree.nvim'
	open_ranger_label = 'Open Ranger'
	update_plugins_label = 'Update plugins using vim-plug'
	quit_neovim_label = 'Quit NeoVim'
end

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
if vim.g.show_ascii_logo then
	dashboard.section.header.val = vim.fn.readfile(vim.fn.expand(vim.g.CONFIG_PATH)..'/logo/logo.txt')
else
	dashboard.section.header.val = 'extra.nvim'
end
if os.getenv('HOME') ~= nil then
	if vim.fn.executable('exnvim') == 1 then
		local readfile = io.popen('exnvim version')
		if vim.g.show_ascii_logo then
			table.insert(dashboard.section.header.val, readfile:read())
		else
			dashboard.section.header.val = dashboard.section.header.val .. ' ' .. readfile:read()
		end
		readfile:close()
	end
end
dashboard.section.header.opts.hl = "ExNvimLogo"
dashboard.section.buttons.val = {}
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button("e", "  "..new_file_label, ":enew <CR>"..(vim.g.edit_new_file and ":startinsert<CR>" or "")),
	dashboard.button("f", "󰥨  "..find_file_label, ":call FuzzyFind()<CR>"),
	dashboard.button("l", "  "..load_last_session_label, ":SessionLoadLast<CR>"),
	dashboard.button("t", "  "..open_terminal_label, ":call OpenTerm(\"\")<CR>"),
	dashboard.button("r", "󰚰  "..recently_opened_files_label, ":lua require('telescope').extensions.recent_files.pick()<CR>"),
})
if plugin_installed('neo-tree') then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button("h", "󰙅  "..open_nerdtree_label, ":Neotree<CR>:silent only<CR>")
	})
end
if vim.fn.executable('ranger') == 1 then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button("o", "  "..open_ranger_label, ":call OpenRanger(\"./\")<CR>")
	})
end
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button("u", "󰚰  "..update_plugins_label, ":PlugUpdate<CR>"),
	dashboard.button("q", "  "..quit_neovim_label, ":qa<CR>"),
})
if vim.g.enable_fortune then
	if dashboard.section.footer.val == "" then
		local handle = io.popen('fortune')
		local fortune = handle:read("*a")
		handle:close()
		dashboard.section.footer.val = fortune
	end
else
	if dashboard.section.footer.val then
		dashboard.section.footer.val = ""
	end
end
alpha.setup(dashboard.opts)
