require('notify').setup({
	stages = "fade_in_slide_out",
	timeout = 0,
	top_down = true,
	fps = vim.g.fast_terminal and 30 or 10,
	render = "compact",
})

vim.oldnotify = vim.notify
vim.notify = require('notify')
