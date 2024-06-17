require('lib.lists.concat')

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
	dashboard.button( "e", "  New file" , ":enew <CR>:startinsert<CR>"),
	dashboard.button( "f", "󰥨  Find file" , ":call FuzzyFind()<CR>"),
	dashboard.button( "l", "  Load last session" , ":SessionLoadLast<CR>"),
	dashboard.button( "t", "  Open Terminal" , ":call OpenTerm(\"\")<CR>"),
	dashboard.button( "r", "󰚰  Recently opened files" , ":lua require('telescope').extensions.recent_files.pick()<CR>"),
})
if vim.fn.isdirectory(vim.g.LOCALSHAREPATH.."/site/pack/packer/start/nerdtree") == 1 then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button( "h", "󰙅  Open NERDTree" , ":NERDTreeToggle<CR>:silent only<CR>")
	})
end
if vim.fn.executable('ranger') == 1 then
	dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
		dashboard.button( "o", "  Open Ranger" , ":call OpenRanger(\"./\")<CR>")
	})
end
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button( "q", "  Quit NeoVim" , ":qa<CR>"),
})
if vim.g.enable_fortune then
	local handle = io.popen('fortune')
	local fortune = handle:read("*a")
	handle:close()
	dashboard.section.footer.val = fortune
end
alpha.setup(dashboard.opts)
