if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-dap-python") == 1 then
	require('packages.dap.python.init')
end
if vim.fn.isdirectory(vim.fn.expand(vim.g.LOCALSHAREPATH).."/site/pack/packer/start/nvim-dap-go") == 1 then
	require('packages.dap.go.init')
end
