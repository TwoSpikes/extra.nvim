require('lib.lists.compare')

function plugin_installed(name)
	return vim.fn.PluginInstalled(name) == 1
end
function plugin_exists(name)
	return vim.fn.PluginExists(name) == 1
end
function plugin_delete(name)
	vim.fn.PluginDelete(name)
end
