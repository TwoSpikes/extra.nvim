require('lib.lists.compare')

function plugin_installed(name)
	return vim.fn.PluginInstalled(name) == 1
end
