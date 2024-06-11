local alpha = require'alpha'
local dashboard = require'alpha.themes.dashboard'
dashboard.section.header.val = 'alpha-nvim'
dashboard.section.buttons.val = {
	dashboard.button( "e", "  New file" , ":enew <BAR> startinsert <CR>"),
	dashboard.button( "l", "  Load last session" , ":SessionLoadLast<CR>"),
	dashboard.button( "t", "  Open Terminal" , ":call OpenTerm(\"\")<CR>"),
	dashboard.button( "n", "  Open NERDTree" , ":NERDTreeToggle<CR>"),
	dashboard.button( "r", "  Open Ranger" , ":call OpenRanger(\"./\")<CR>"),
	dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),
}
local handle = io.popen('fortune')
local fortune = handle:read("*a")
handle:close()
dashboard.section.footer.val = fortune
alpha.setup(dashboard.opts)
