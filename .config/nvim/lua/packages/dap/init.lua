require('lib.vim.plugins')

if plugin_installed("nvim-dap-python") then
	require('packages.dap.python.init')
end
if plugin_installed("nvim-dap-go") then
	require('packages.dap.go.init')
end
