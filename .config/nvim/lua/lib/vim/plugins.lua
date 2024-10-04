require('lib.lists.compare')

function plugin_installed(name)
	dir = vim.fn.expand(vim.g.LOCALSHAREPATH.."/site/pack/packer/start/"..name)
	return vim.fn.isdirectory(dir) == 1 and not equals(vim.fn.readdir(dir), {".git"})
end
