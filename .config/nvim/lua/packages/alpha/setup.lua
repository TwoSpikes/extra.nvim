require('lib.lists.concat')

if vim.g.language == 'russian' then
	new_file_label = 'Новый файл'
	find_file_label = 'Найти файл'
	load_last_session_label = 'Открыть предыдущую сессию'
	open_terminal_label = 'Открыть терминал'
	recently_opened_files_label = 'Предыдущие открытые файлы'
	open_nerdtree_label = 'Открыть NERDTree'
	open_ranger_label = 'Открыть ranger'
	quit_neovim_label = 'Выйти из NeoVim'
else
	new_file_label = 'New file'
	find_file_label = 'Find file'
	load_last_session_label = 'Load last session'
	open_terminal_label = 'Open Terminal'
	recently_opened_files_label = 'Recently opened files'
	open_nerdtree_label = 'Open NERDTree'
	open_ranger_label = 'Open Ranger'
	quit_neovim_label = 'Quit NeoVim'
end

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = 'extra.nvim'
if os.getenv('HOME') ~= nil then
	if vim.fn.executable('dotfiles') == 1 then
		local readfile = io.popen('dotfiles version')
		dashboard.section.header.val = dashboard.section.header.val .. ' ' .. readfile:read()
		readfile:close()
	end
end
dashboard.section.buttons.val = {}
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button("e", "  "..new_file_label, ":enew <CR>:startinsert<CR>"),
	dashboard.button("f", "󰥨  "..find_file_label, ":call FuzzyFind()<CR>"),
	dashboard.button("l", "  "..load_last_session_label, ":SessionLoadLast<CR>"),
	dashboard.button("t", "  "..open_terminal_label, ":call OpenTerm(\"\")<CR>"),
	dashboard.button("r", "󰚰  "..recently_opened_files_label, ":lua require('telescope').extensions.recent_files.pick()<CR>"),
})
if vim.fn.isdirectory(vim.g.LOCALSHAREPATH.."/site/pack/packer/start/nerdtree") == 1 then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button("h", "󰙅  "..open_nerdtree_label, ":NERDTreeToggle<CR>:silent only<CR>")
	})
end
if vim.fn.executable('ranger') == 1 then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button("o", "  "..open_ranger_label, ":call OpenRanger(\"./\")<CR>")
	})
end
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button("q", "  "..quit_neovim_label, ":qa<CR>"),
})
if vim.g.enable_fortune then
	local handle = io.popen('fortune')
	local fortune = handle:read("*a")
	handle:close()
	dashboard.section.footer.val = fortune
end
alpha.setup(dashboard.opts)
