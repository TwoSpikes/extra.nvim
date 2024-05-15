if vim.g.setup_lsp == false then
	return
end

require('mason').setup({
    ui = {
        width = 1,
        height = 1,
    },
})
-- vim.cmd('MasonInstall beautysh')
require('mason-lspconfig').setup({
    ensure_installed = {
        'vimls',
        'bashls',
        'pyright',
    },
})

vim.api.nvim_create_user_command(
    'Vimls',
    [[ lua vim.lsp.start({
        name = 'vimls',
        cmd = {'vim-language-server', '--stdio'},
        root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
    }) ]],
    { bang = true }
)
vim.api.nvim_create_user_command(
    'Bashls',
    [[ lua vim.lsp.start({
        name = 'bashls',
        cmd = {'bash-language-server', '--stdio'},
        root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
    }) ]],
    { bang = true }
)
vim.api.nvim_create_user_command(
    'Pyright',
    [[ lua vim.lsp.start({
        name = 'pyright',
		cmd = {'pyright', '--stdio'},
		root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
    }) ]],
	{ bang = true }
)
vim.api.nvim_create_user_command(
	'Codelldb',
	[[ lua vim.lsp.start({
		name = 'codelldb',
		cmd = {'codelldb', '--stdio'},
		root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
	}) ]],
	{ bang = true }
)
vim.keymap.set('n', '<leader>sld', [[
    :lua =table_dump(vim.lsp.get_active_clients())
]])

vim.ui.select = require('lspactions').select
vim.ui.input = require('lspactions').input
