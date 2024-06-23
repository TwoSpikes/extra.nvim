require('cinnamon').setup({
	-- KEYMAPS:
	default_keymaps = true,   -- Create default keymaps.
	extra_keymaps = true,    -- Create extra keymaps.
	extended_keymaps = true, -- Create extended keymaps.
	override_keymaps = true, -- The plugin keymaps will override any existing keymaps.

	-- OPTIONS:
	always_scroll = false,    -- Scroll the cursor even when the window hasn't scrolled.
	centered = false,          -- Keep cursor centered in window when using window scrolling.
	disabled = false,         -- Disables the plugin.
	default_delay = 7,        -- The default delay (in ms) between each line when scrolling.
	hide_cursor = false,      -- Hide the cursor while scrolling. Requires enabling termguicolors!
	horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
	max_length = -1,          -- Maximum length (in ms) of a command. The line delay will be
							  -- re-calculated. Setting to -1 will disable this option.
	scroll_limit = 0,       -- Max number of lines moved before scrolling is skipped. Setting
							  -- to -1 will disable this option.
})
