require('lib.lists.compare')

function plugin_installed(name)
	return pcall(require, name)
end
function plugin_exists(name)
	return vim.fn.PluginExists(name) == 1
end
function plugin_delete(name)
	vim.fn.PluginDelete(name)
end
function TSParserNotInstalled(name)
	local timer = vim.uv.new_timer()
	timer:start(0, 0, vim.schedule_wrap(function() 
		require('nvim-treesitter.install').commands.TSInstall['run'](name)
	end))
end
