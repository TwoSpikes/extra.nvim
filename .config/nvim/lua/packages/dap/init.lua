require('lib.vim.plugins')

if plugin_installed("dap-python") then
	require('packages.dap.python.init')
end
if plugin_installed("dap-go") then
	require('packages.dap.go.init')
end
