function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = 'extra.nvim'
dashboard.section.buttons.val = {
	dashboard.button( "e", "  New file" , ":enew <CR>:startinsert<CR>"),
	dashboard.button( "f", "󰥨  Find file lol" , ":call FuzzyFind()<CR>"),
	dashboard.button( "l", "  Load last session" , ":SessionLoadLast<CR>"),
	dashboard.button( "t", "  Open Terminal" , ":call OpenTerm(\"\")<CR>"),
}
if vim.fn.isdirectory(vim.g.LOCALSHAREPATH.."/site/pack/packer/start/nerdtree") == 1 then
	table.insert(dashboard.section.buttons.val, dashboard.button( "h", "󰙅  Open NERDTree" , ":NERDTreeToggle<CR>:silent only<CR>"))
end
if vim.fn.executable('ranger') == 1 then
	table.insert(dashboard.section.buttons.val, dashboard.button( "r", "  Open Ranger" , ":call OpenRanger(\"./\")<CR>"))
end
dashboard.section.buttons.val = TableConcat(dashboard.section.buttons.val, {
	dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),
})
if vim.g.enable_fortune then
	local handle = io.popen('fortune')
	local fortune = handle:read("*a")
	handle:close()
	dashboard.section.footer.val = fortune
end
alpha.setup(dashboard.opts)
