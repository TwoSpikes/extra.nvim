require('persisted').setup({
  should_autosave = function()
    -- do not autosave if the alpha dashboard is the current filetype
	return vim.bo.filetype ~= 'alpha'
  end,
})

require('telescope').load_extension('persisted')
require('telescope').setup({
  defaults = {
    …
  },
  extensions = {
    persisted = {
      layout_config = { width = 0.55, height = 0.55 }
    }
  }
})
