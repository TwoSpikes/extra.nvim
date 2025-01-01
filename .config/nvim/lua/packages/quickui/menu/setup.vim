if !has('nvim') || !PluginExists('vim-quickui')
	finish
endif

function! ChangeLanguage()
	if g:language ==# 'russian'
		let s:off = 'Выкл.'
		let s:on = 'Вкл.'
		let s:disable = 'Выключить'
		let s:enable = 'Включить'
		let s:make_relative = 'относительными'
		let s:make_absolute = 'абсолютными'

		let s:file_label = '&f:Файл'
		let s:new_file_label = '&w:Новый файл'
		let s:close_label = '&o:Закрыть'
		let s:force_close_label = '&e:Закрыть всё равно'
		let s:save_label = '&s:Сохранить'
		let s:save_all_label = '&a:Сохранить всё'
		let s:save_as_label = '&v:Сохранить как'
		let s:save_as_and_edit_label = '&i:Сохранить как и зайти'
		let s:update_plugins_label = '&p:Обновить плагины'
		let s:update_coc_label = "&c:Обновить coc lsp'ы"
		let s:update_treesitter_label = '&t:Обновить TreeSitter'
		let s:redraw_screen_label = '&n:Перерисовать экран'
		let s:hide_highlightings_label = '&d:Скрыть подсвечивание'
		let s:toggle_fullscreen_label = '&f:Переключ.полноэкр.реж.'
		let s:exit_label = '&x:Выйти'
		let s:exit_wo_confirm_label = '&m:Выйти всё равно'

		let s:window_label = '&w:Окно'
		let s:kill_buffer_label = '&u:Убить буффер'
		let s:select_buffer_label = '&s:Выбрать буффер'
		let s:search_word_using_spectre_label = '&w:Искать слово в Spectre'
		let s:open_file_in_tab_label = '&t:Открыть файл в нов.вкл.'
		let s:open_file_in_buffer_label = '&b:Открыть файл а буффере'
		let s:toggle_file_tree_label = '&f:Переключ.дерево файлов'
		let s:telescope_fuzzy_find_label = '&z:Поиск Telescope'
		let s:open_file_using_ranger_label = '&r:Открыть файл в ranger'
		let s:recently_opened_files_label = '&c:Недавно открытые файлы'
		let s:make_window_only_label = '&m:Закрыть остальные окна'
		let s:previous_window_label = '&p:Предыдущее окно'
		let s:next_window_label = '&n:Следующее окно'
		let s:horizontally_split_label = '&i:Горизонтальный сплит'
		let s:vertically_split_label = '&v:Вертикальный сплит'
		let s:open_terminal_label = '&o:Открыть терминал'
		let s:open_far_mc_label = '&e:Открыть Far/Mc'
		let s:open_lazygit_label = '&g:Открыть lazygit'
		let s:open_start_menu_label = '&a:Открыть главное меню'

		let s:text_label = '&t:Текст'
		let s:copy_line_label = '&y:Копировать строку'
		let s:delete_line_label = '&d:Удалить строку'
		let s:cut_line_label = '&u:Вырезать строку'
		let s:paste_after_label = '&p:Вставить после'
		let s:paste_before_label = '&e:Вставить перед'
		let s:join_lines_label = '&n:Соединить строки'
		let s:force_join_lines_label = '&r:Соединить строки!'
		let s:forward_find_whole_word_label = '&f:Искать вперёд <слово>'
		let s:backward_find_whole_word_label = '&b:Искать назад <слово>'
		let s:forward_find_word_label = '&r:Искать вперёд слово'
		let s:backward_find_word_label = '&a:Искать назад слово'
		let s:comment_out_label = '&c:Закомментировать'
		let s:uncomment_out_label = '&u:Раскомментировать'
		let s:go_to_multicursor_mode_label = '&m:Режим мультикурсора'
		let s:show_hlgroup_label = 'Показать hl&group'
		let s:whence_hlgroup_label = '&w:Откуда hlgroup'
		let s:select_all_label = '&s:Выбрать всё'
		let s:toggle_tagbar_label = 'Переключить &tagbar'
		let s:generate_annotation_label = '&o:Создать аннотацию'

		let s:lsp_label = '&LSP'
		let s:git_label = '&Git'

		let s:option_label = '&o:Опции'
		let s:set_spell = '&s:Проверка орфографии'
		let s:set_paste = '&p:Режим вставки'
		let s:set_cursor_column = '&c:Подсветка колонки'
		let s:set_cursor_line = '&i:Подсветка линии'
		let s:cursor_line_style = '&u:Стиль подсветки линии'
		let s:set_line_numbers = '&n:Номера строк'
		let s:line_numbers_style = '&s:Стиль номеров строк'

		let s:config_label = '&c:Конфиг'
		let s:open_init_vim = 'Открыть &init.vim'
		let s:open_plugins_list = '&p:Открыть список плагинов'
		let s:open_plugins_setup = '&u:Открыть установки плагинов'
		let s:open_lsp_settings = 'Открыть настройки L&SP'
		let s:open_exnvim_config = 'Открыть конфигурацию ex&nvim'
		let s:open_colorschemes_dir = '&c:Отк.дир-ю с цветов.схемами'
		let s:reload_init_vim = '&r:Перезагрузить init.vim'
		let s:reload_plugins_list = '&e:Перезагрузить список плаг.'
		let s:reload_plugins_setup = '&o:Перезагруз.установки плаг.'
		let s:reload_lsp_setup = '&a:Перезагрузит.установки LSP'
		let s:generate_exnvim_config = '&g:Сгенериров.конфигур.exnvim'
		let s:reload_exnvim_config = 'Перезагруз.конфигурац.e&xnvim'
		let s:open_termux_config = 'Открыть конфигурац.&Termux'
		let s:reload_termux_config = 'Перезагруз.конфигурац.Ter&mux'

		let s:help_label = '&h:Помощь'
		let s:vim_cheatsheet = '&c:Vim шпаргалка'
		let s:exnvim_cheatsheet = 'Шпаргалка &extra.nvim'
		let s:tips = '&p:Советы'
		let s:tutorial = '&t:Руководство'
		let s:quick_reference = '&q:Краткая справка'
		let s:summary = '&s:Краткое содержание'
		let s:intro_screen = '&i:Начальный экран'
		if has('nvim')
			let s:vim_version = 'Версия Neo&Vim'
		else
			let s:vim_version = 'Версия &Vim'
		endif
	else
		let s:off = 'Off'
		let s:on = 'On'
		let s:disable = 'Disable'
		let s:enable = 'Enable'
		let s:make_relative = 'relative'
		let s:make_absolute = 'absolute'

		let s:file_label = '&File'
		let s:new_file_label = 'Ne&w file'
		let s:close_label = 'Cl&ose'
		let s:force_close_label = 'Force clos&e'
		let s:save_label = '&Save'
		let s:save_all_label = 'Save &all'
		let s:save_as_label = 'Sa&ve as'
		let s:save_as_and_edit_label = 'Save as and ed&it'
		let s:update_plugins_label = 'Update &plugins'
		let s:update_coc_label = 'Update &coc servers'
		let s:update_treesitter_label = 'Update &TreeSitter'
		let s:redraw_screen_label = 'Redraw scree&n'
		let s:hide_highlightings_label = 'Hi&de highlightings'
		let s:toggle_fullscreen_label = 'Toggle &fullscreen'
		let s:exit_label = 'E&xit'
		let s:exit_wo_confirm_label = 'Exit w/o confir&m'

		let s:window_label = '&Window'
		let s:kill_buffer_label = 'Kill b&uffer'
		let s:select_buffer_label = '&Select buffer'
		let s:search_word_using_spectre_label = 'Find &word using Spectre'
		let s:open_file_in_tab_label = 'Open file in &tab'
		let s:open_file_in_buffer_label = 'Open file in &buffer'
		let s:toggle_file_tree_label = 'Toggle &file tree'
		let s:telescope_fuzzy_find_label = 'Telescope fu&zzy find'
		let s:open_file_using_ranger_label = 'Open file using &ranger'
		let s:recently_opened_files_label = 'Re&cently opened files'
		let s:make_window_only_label = '&Make window only'
		let s:previous_window_label = '&Previous window'
		let s:next_window_label = '&Next window'
		let s:horizontally_split_label = 'Hor&izontally split'
		let s:vertically_split_label = '&Vertically split'
		let s:open_terminal_label = '&Open terminal'
		let s:open_far_mc_label = 'Op&en Far/Mc'
		let s:open_lazygit_label = 'Open lazy&git'
		let s:open_start_menu_label = 'Open st&art menu'

		let s:text_label = '&Text'
		let s:copy_line_label = 'Cop&y line'
		let s:delete_line_label = '&Delete line'
		let s:cut_line_label = 'C&ut line'
		let s:paste_after_label = '&Paste after'
		let s:paste_before_label = 'Past&e before'
		let s:join_lines_label = 'Joi&n lines'
		let s:force_join_lines_label = 'Fo&rce join lines'
		let s:forward_find_whole_word_label = '&Forward find <word>'
		let s:backward_find_whole_word_label = '&Backward find <word>'
		let s:forward_find_word_label = 'Fo&rward find word'
		let s:backward_find_word_label = 'B&ackward find word'
		let s:comment_out_label = '&Comment out'
		let s:uncomment_out_label = '&Uncomment out'
		let s:go_to_multicursor_mode_label = 'Go to &multicursor mode'
		let s:show_hlgroup_label = 'Show hl&group'
		let s:whence_hlgroup_label = '&Whence hlgroup'
		let s:select_all_label = '&Select all'
		let s:toggle_tagbar_label = '&Toggle tagbar'
		let s:generate_annotation_label = 'Generate ann&otation'

		let s:lsp_label = '&LSP'
		let s:git_label = '&Git'

		let s:option_label = '&Option'
		let s:set_spell = 'Set &Spell'
		let s:set_paste = 'Set &Paste'
		let s:set_cursor_column = 'Set Cursor &Column'
		let s:set_cursor_line = 'Set Cursor L&ine'
		let s:cursor_line_style = 'C&ursor line style'
		let s:set_line_numbers = 'Set Line &numbers'
		let s:line_numbers_style = 'Line numbers &style'

		let s:config_label = '&Config'
		let s:open_init_vim = 'Open &init.vim'
		let s:open_plugins_list = 'Open &plugins list'
		let s:open_plugins_setup = 'Open plugins set&up'
		let s:open_lsp_settings = 'Open lsp &settings'
		let s:open_exnvim_config = 'Open ex&nvim config'
		let s:open_colorschemes_dir = 'Open &colorschemes dir'
		let s:reload_init_vim = '&Reload init.vim'
		let s:reload_plugins_list = 'R&eload plugins list'
		let s:reload_plugins_setup = 'Rel&oad plugins setup'
		let s:reload_lsp_setup = 'Relo&ad LSP setup'
		let s:generate_exnvim_config = '&Generate extra.nvim config'
		let s:reload_exnvim_config = 'Reload e&xnvim config'
		let s:open_termux_config = 'Open &Termux config'
		let s:reload_termux_config = 'Reload Ter&mux config'

		let s:help_label = '&Help'
		let s:vim_cheatsheet = 'Vim &cheatsheet'
		let s:exnvim_cheatsheet = '&extra.nvim cheatsheet'
		let s:tips = 'Ti&ps'
		let s:tutorial = '&Tutorial'
		let s:quick_reference = '&Quick Reference'
		let s:summary = '&Summary'
		let s:intro_screen = '&Intro screen'
		if has('nvim')
			let s:vim_version = 'NeoVim &version'
		else
			let s:vim_version = 'Vim &version'
		endif
	endif
endfunction

function! ChangeNames()
	if mode() !~# '^n'
		if g:language ==# 'russian'
			let s:esc_label = "&r:Выйти в нормальный режим"
		else
			let s:esc_label = "Go to No&rmal mode"
		endif
		let s:esc_command = 'exec "normal! \<c-\>\<c-n>"'
		return
	else
		if exists('g:Vm')
			if g:Vm['buffer'] !=# 0
				if g:language ==# 'russian'
					let s:esc_label = "&r:Выйти из мультикурсора"
				else
					let s:esc_label = "Exit multicu&rsor"
				endif
				let s:esc_command = b:VM_Selection.Vars.noh."call vm#reset()"
				return
			endif
		endif
		if @/ !=# ""
			if g:language ==# 'russian'
				let s:esc_label = "&r:Остановить поиск"
			else
				let s:esc_label = "Stop sea&rching"
			endif
			let s:esc_command = 'let @/ = ""'
			return
		endif
		if g:language ==# 'russian'
			let s:esc_label = "&r:Останов.текущ.команду"
		else
			let s:esc_label = "Stop cu&rrent command"
		endif
		let s:esc_command = "normal! \<esc>"
		return
	endif
endfunction

function! RebindMenus()
	" clear all the menus
	call quickui#menu#reset()

	" install a 'File' menu, use [text, command] to represent an item.
	call quickui#menu#install(s:file_label, [
				\ [(g:quickui_icons?"󰈙 ":"").s:new_file_label."\t:new", 'new', 'Creates a new buffer'],
				\ [(g:quickui_icons?" ":"").s:close_label."\tq", 'quit', 'Closes the current window'],
				\ [(g:quickui_icons?" ":"").s:force_close_label."\tQ", 'quit!', 'Closes the current window without saving changes'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰆓 ":"").s:save_label."\tCtrl-x s", 'write', 'Save changes in current buffer'],
				\ [(g:quickui_icons?"󰆔 ":"").s:save_all_label."\tCtrl-x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
				\ ])
	if exists(':SaveAs')
		call quickui#menu#install(s:file_label, [
					\ [(g:quickui_icons?"󰳻 ":"").s:save_as_label."\tLEAD Ctrl-s", 'call SaveAs()', 'Save current file as ...' ],
					\ ])
	endif
	if exists(':SaveAsAndRename')
		call quickui#menu#install(s:file_label, [
					\ [(g:quickui_icons?"󰳻 ":"").s:save_as_and_edit_label."\tLEAD Ctrl-r", 'call SaveAsAndRename()', 'Save current file as ... and edit it' ],
					\ ])
	endif
	call quickui#menu#install(s:file_label, [
				\ ["--", ''],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_plugins_label."\tLEAD up", 'Pckr sync', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_coc_label."\tLEAD uc", 'CocUpdate', 'Update coc.nvim installed language servers'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_treesitter_label."\tLEAD ut", 'TSUpdate', 'Update installed TreeSitter parsers'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:redraw_screen_label."\tCtrl-l", 'mode', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?" ":"").s:hide_highlightings_label."\tLEAD d", 'nohlsearch', 'Hide search highlightings'],
				\ [(g:quickui_icons?" ":"").s:esc_label."\tesc", s:esc_command, 'Stop searching'],
				\ [(g:quickui_icons?"󰊓 ":"").s:toggle_fullscreen_label."\tLEAD Ctrl-f", 'ToggleFullscreen', 'Toggle fullscreen mode'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_label."\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_wo_confirm_label."\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
				\ ])

	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󱂥 ":"").s:kill_buffer_label."\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
				\ [(g:quickui_icons?" ":"").s:select_buffer_label."\tCtrl-x Ctrl-b", 'call quickui#tools#list_buffer("e")', 'Select buffer to edit in current buffer'],
				\ ])
	if executable('rg')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󱎸 ":"").s:search_word_using_spectre_label."\tLEAD sw", 'exec "lua require(\"spectre\").open_visual({select_word = true})"', 'Select buffer to edit in current buffer'],
					\ ])
	endif
	call quickui#menu#install(s:window_label, [
				\ ["--", ''],
				\ ])
	if has('nvim') && PluginExists('vim-quickui')
		if exists(':Findfile')
			call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?" ":"").s:open_file_in_tab_label."\tCtrl-c c", 'Findfile', 'Open file in new tab'],
					\ ])
		endif
		if exists(':Findfilebuffer')
			call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?" ":"").s:open_file_in_buffer_label."\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
					\ ])
		endif
	endif
	if has('nvim') && PluginInstalled('neo-tree')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󰙅 ":"").s:toggle_file_tree_label."\tCtrl-h", 'Neotree', 'Toggles a file tree'],
					\ ])
	endif
	if has('nvim') && PluginInstalled('telescope')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󰥨 ":"").s:telescope_fuzzy_find_label."\t".(g:compatible!=#"helix"&&g:compatible!=#"helix_hard"?"LEAD ff":"LEAD f"), 'call FuzzyFind()', 'Opens Telescope.nvim find file'],
					\ ])
	endif
	if executable('ranger')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?" ":"").s:open_file_using_ranger_label."\t".(g:compatible==#"helix"||g:compatible==#"helix_hard"?"LEAD xr":"LEAD r"), 'call OpenRangerCheck()', 'Opens ranger to select file to open'],
					\ ])
	endif
	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰚰 ":"").s:recently_opened_files_label."\tLEAD fr", 'lua require("telescope").extensions.recent_files.pick()', 'Show menu to select file from recently opened'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:make_window_only_label."\tCtrl-x 1", 'only', 'Hide all but current window'],
				\ [(g:quickui_icons?" ":"").s:previous_window_label."\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
				\ [(g:quickui_icons?" ":"").s:next_window_label."\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
				\ [(g:quickui_icons?" ":"").s:horizontally_split_label."\tCtrl-x 2", 'split', 'Horizontally split current window'],
				\ [(g:quickui_icons?" ":"").s:vertically_split_label."\tCtrl-x 3", 'vsplit', 'Vertically split current window'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:open_terminal_label."\tLEAD t", 'call SelectPosition("", g:termpos)', 'Opens a terminal'],
				\ ])
	if executable('mc') || executable('far') || executable('far2l')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"").s:open_far_mc_label."\tLEAD m", 'call SelectPosition(g:far_or_mc, g:termpos)', 'Opens Far or Midnight commander'],
				\ ])
	endif
	if executable('lazygit')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"").s:open_lazygit_label."\tLEAD z", 'call SelectPosition("lazygit", g:termpos)', 'Opens Lazygit'],
				\ ])
	endif
	if has('nvim') && PluginInstalled('alpha')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰍜 ":"").s:open_start_menu_label."\tLEAD A", 'call RunAlphaIfNotAlphaRunning()', 'Opens alpha-nvim menu'],
				\ ])
	endif

	" items containing tips, tips will display in the cmdline
	call quickui#menu#install(s:text_label, [
				\ [(g:quickui_icons?"󰆏 ":"").s:copy_line_label."\t".(g:compatible==#"helix"||g:compatible==#"helix_hard"?"xy":"yy"), 'yank', 'Copy the line where cursor is located'],
				\ [(g:quickui_icons?"󰆴 ":"").s:delete_line_label."\t".(g:compatible==#"helix"||g:compatible==#"helix_hard"?"x\"_d":"sd"), 'delete x', 'Delete the line where cursor is located'],
				\ [(g:quickui_icons?"󰆐 ":"").s:cut_line_label."\t".(g:compatible==#"helix"||g:compatible==#"helix_hard"?"xd":"dd"), 'delete _', 'Cut the line where cursor is located'],
				\ [(g:quickui_icons?"󰆒 ":"").s:paste_after_label."\tp", 'normal! p', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?"󰆒 ":"").s:paste_before_label."\tP", 'normal! P', 'Paste copyied text before the cursor'],
				\ [(g:quickui_icons?"  ":"").s:join_lines_label."\tJ", 'join', 'Join current and next line and put between them a space'],
				\ [(g:quickui_icons?"  ":"").s:force_join_lines_label."\tgJ", 'normal! p', 'Join current and next line and leave blanks as it is'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:forward_find_whole_word_label."\t".(g:compatible==#"helix_hard"?"eb*":"*"), 'normal! *', 'Forwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"").s:backward_find_whole_word_label."\t".(g:compatible==#"helix_hard"?"eb#":"#"), 'normal! #', 'Backwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"").s:forward_find_word_label."\t".(g:compatible==#"helix_hard"?"ebg*":"g*"), 'normal! g*', 'Forwardly find word under cursor'],
				\ [(g:quickui_icons?" ":"").s:backward_find_word_label."\t".(g:compatible==#"helix_hard"?"ebg#":"g#"), 'normal! g#', 'Backwardly find word under cursor'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰅺 ":"").s:comment_out_label."\tLEAD c", 'call '.(mode() =~# '^n'?'N':'X').'_CommentOutDefault()', 'Comment out line under cursor'],
				\ [(g:quickui_icons?"󱗡 ":"").s:uncomment_out_label."\tLEAD C", 'call '.(mode() =~# '^n'?'N':'X').'_UncommentOutDefault()', 'Uncomment line under cursor'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰗧 ":"").s:go_to_multicursor_mode_label."\tCtrl-n", 'call vm#commands#ctrln(1)', 'Go to multicursor mode'],
				\ [(g:quickui_icons?" ":"").s:show_hlgroup_label."", 'call SynGroup()', 'Show hlgroup name under cursor'],
				\ [(g:quickui_icons?" ":"").s:whence_hlgroup_label, 'call WhenceGroup()', 'Show whence hlgroup under cursor came'],
				\ [(g:quickui_icons?"󰒆 ":"").s:select_all_label."\t".(g:compatible==#"helix"||g:compatible==#"helix_hard"?"%":"Ctrl-x h"), 'call SelectAll()', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?" ":"").s:toggle_tagbar_label."\tCtrl-t", 'TagbarToggle', 'Toggles tagbar'],
				\ [(g:quickui_icons?" ":"").s:generate_annotation_label."\tLEAD n", 'Neogen', 'Generate Neogen annotation (:h neogen)'],
				\ ])

	call quickui#menu#install(s:lsp_label, [
				\ ["Coc &previous diagnostic\t[g", 'call CocActionAsync("diagnosticPrevious")', 'Go to previous diagnostic'],
				\ ["Coc &next diagnostic\t]g", 'call CocActionAsync("diagnosticNext")', 'Go to next diagnostic'],
				\ ["Go to &definition\tgd", 'call CocActionAsync("jumpDefinition")', 'Jump to definition'],
				\ ["Go to &type definition\tgy", 'call CocActionAsync("jumpTypeDefinition")', 'Jump to type definition'],
				\ ["Go to &implementation\tgi", 'call CocActionAsync("jumpImplementation")', 'Jump to implementation'],
				\ ["G&o to references\tgr", 'call CocActionAsync("jumpReferences")', 'Jump to references'],
				\ ["--", '' ],
				\ ["Code &actions selected\tLEAD a", 'call CocActionAsync("codeAction", visualmode())', 'Apply code actions for selected code'],
				\ ["Code actions &cursor\tLEAD ac", 'call CocActionAsync("codeAction", "cursor")', 'Apply code actions for current cursor position'],
				\ ["Code actions &buffer\tLEAD as", 'call CocActionAsync("codeAction", "", ["source"], v:true)', 'Apply code actions for current buffer'],
				\ ["Fi&x current line\tLEAD qf", 'call CocActionAsync("doQuickfix")', 'Apply the most preferred quickfix action to fix diagnostic on the current line'],
				\ ["--", '' ],
				\ ["&Refactor\tLEAD Re", 'call CocActionAsync("codeAction", "cursor", ["refactor"], v:true)', 'Codeaction refactor cursor'],
				\ ["Refactor s&elected\tLEAD R", 'call CocActionAsync("codeAction", visualmode(), ["refactor"], v:true)', 'Codeaction refactor selected'],
				\ ["--", '' ],
				\ ["C&ode lens current line\tLEAD cl", 'call CocActionAsync("codeLensAction")', 'Run the Code Lens action on the current line'],
				\ ["&Show documentation\tK", 'call ShowDocumentation()', 'Show documentation in preview window'],
				\ ["Rename s&ymbol\tLEAD rn", 'call CocActionAsync("rename")', 'Rename symbol under cursor'],
				\ ["&Format selected\tLEAD f", 'call CocActionAsync("formatSelected", visualmode())', 'Format selected code'],
				\ ["Fold c&urrent buffer\t:Fold", 'Fold', 'Make folds for current buffer'],
				\ ])

	if has('nvim') && PluginExists('vim-fugitive')
		call quickui#menu#install(s:git_label, [
				\ ["&Commit\tLEAD gc", 'Git commit --verbose', 'Commit using fugitive.vim'],
				\ ["Commit &all\tLEAD ga", 'Git commit --verbose --all', 'Commit all using fugitive.vim'],
				\ ["Commit a&mend\tLEAD gA", 'Git commit --verbose --amend', 'Amend commit using fugitive.vim'],
				\ ["P&ull\tLEAD gp", 'Git pull', 'Pull repository using fugitive.vim'],
				\ ["&Push\tLEAD gP", 'Git push', 'Push repository using fugitive.vim'],
				\ ["&Reset soft\tLEAD gr", 'Git reset --soft', 'Reset repository using fugitive.vim'],
				\ ["Reset har&d\tLEAD gR", 'Git reset --hard', 'Hardly reset repository using fugitive.vim'],
				\ ["Reset mi&xed\tLEAD gm", 'Git reset --mixed', 'Mixed reset repository using fugitive.vim'],
				\ ["&Status\tLEAD gs", 'Git status', 'Show repository status using fugitive.vim'],
				\ ])
	endif
	if has('nvim') && PluginExists('diffview.nvim')
		call quickui#menu#install(s:git_label, [
				\ ["&View diff\tLEAD gd", 'DiffviewOpen HEAD', 'Show diff'],
				\ ])
	endif

	call quickui#menu#install(s:option_label, [
				\ [(g:quickui_icons?"󰓆 ":"").s:set_spell." %{&spell?\"".s:off."\":\"".s:on."\"}", 'set spell!', "%{&spell?\"".s:disable."\":\"".s:enable."\"} spell checking"],
				\ [(g:quickui_icons?"󰆒 ":"").s:set_paste." %{&paste?\"".s:off."\":\"".s:on."\"}", 'set paste!', 'Obsolete thing'],
				\ ["--", ''],
				\ [(g:quickui_icons?"  ":"").s:set_cursor_column." %{g:cursorcolumn?\"".s:off."\":\"".s:on."\"}", 'let g:cursorcolumn=!g:cursorcolumn|call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)', "%{g:cursorcolumn?\"".s:disable."\":\"".s:enable."\"} current column highlighting"],
				\ [(g:quickui_icons?"  ":"").s:set_cursor_line." %{g:cursorline?\"".s:off."\":\"".s:on."\"}", 'let g:cursorline=!g:cursorline|call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)', "%{g:cursorline?\"".s:disable."\":\"".s:enable."\"} current line highlighting"],
				\ ])
	if exists('g:cursorline_style_supported') && len(g:cursorline_style_supported) ># 1
		call quickui#menu#install(s:option_label, [
					\ [(g:quickui_icons?"  ":"").s:cursor_line_style.': %{g:cursorline_style_supported[g:cursorline_style]}', 'let g:cursorline_style=g:cursorline_style==#len(g:cursorline_style_supported)-1?0:g:cursorline_style+1|call Update_CursorLine_Style()', "%{g:cursorline?\"".s:disable."\":\"".s:enable."\"} current line highlighting"],
					\ ])
	endif
	call quickui#menu#install(s:option_label, [
				\ [(g:quickui_icons?" ":"").s:set_line_numbers." %{g:linenr?\"".s:off."\":\"".s:on."\"}", 'let g:linenr=!g:linenr|if !g:linenr|call PreserveAndDo("call STCNoAll()", v:true, v:true)|else|call PreserveAndDo("call NumbertoggleAll(mode())", v:true, v:true)|endif', "%{g:linenr?\"".s:disable."\":\"".s:enable."\"} line numbers"],
				\ [(g:quickui_icons?" ":"").s:line_numbers_style.': %{g:linenr_style}', 'let g:linenr_style=g:linenr_style==#"relative"?"absolute":"relative"|if g:linenr|call PreserveAndDo("call NumbertoggleAll(mode())", v:true, v:true)|endif', "Make line numbers %{g:linenr_style==#\"absolute\"?\"".s:make_relative."\":\"".s:make_absolute."\"}"],
				\ ])

	call quickui#menu#install(s:config_label, [
			\ [s:open_init_vim."\tLEAD ve", 'call SelectPosition(g:CONFIG_PATH."/init.vim", g:stdpos)', 'Open '.g:CONFIG_PATH.'/init.vim'],
			\ [s:open_plugins_list."\tLEAD vi", 'call SelectPosition(g:PLUGINS_INSTALL_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_INSTALL_FILE_PATH],
			\ [s:open_plugins_setup."\tLEAD vs", 'call SelectPosition(g:PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_SETUP_FILE_PATH],
			\ [s:open_lsp_settings."\tLEAD vl", 'call SelectPosition(g:LSP_PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:LSP_PLUGINS_SETUP_FILE_PATH.' (deprecated due to coc.nvim)'],
			\ [s:open_exnvim_config."\tLEAD vj", 'call SelectPosition(g:EXNVIM_CONFIG_PATH, g:stdpos)', 'Open '.g:EXNVIM_CONFIG_PATH],
			\ [s:open_colorschemes_dir."\tLEAD vc", 'call SelectPosition($VIMRUNTIME."/colors", g:dirpos)', 'Open colorschemes directory'],
			\ ["--", ''],
			\ [s:reload_init_vim."\tLEAD se", 'exec "source" g:CONFIG_PATH."/vim/exnvim/reload.vim"', 'Reload Vim/NeoVim config'],
			\ [s:reload_plugins_list."\tLEAD si", 'exec "source ".g:PLUGINS_INSTALL_FILE_PATH', 'Install plugins in '.g:PLUGINS_INSTALL_FILE_PATH],
			\ [s:reload_plugins_setup."\tLEAD ss", 'exec "source ".g:PLUGINS_SETUP_FILE_PATH', 'Reconfigure plugins'],
			\ [s:reload_lsp_setup."\tLEAD sl", 'exec "source ".g:LSP_PLUGINS_SETUP_FILE_PATH', 'Reconfigure LSP plugins (deprecated due to coc.nvim)'],
			\ ["--", ''],
			\ ])
	if executable('exnvim')
		call quickui#menu#install(s:config_label, [
			\ [s:generate_exnvim_config."\tLEAD G", 'GenerateExNvimConfig', 'Regenerate extra.nvim config'],
			\ ])
	endif
	if filereadable(g:EXNVIM_CONFIG_PATH)
		call quickui#menu#install(s:config_label, [
					\ [s:reload_exnvim_config."\tLEAD sj", 'exec "source" g:CONFIG_PATH."/vim/exnvim/reload_config.vim"', 'Reload extra.nvim config'],
			\ ])
	endif
	if $TERMUX_VERSION !=# ""
		call quickui#menu#install(s:config_label, [
					\ ["--", ''],
					\ [s:open_termux_config, 'call SelectPosition(g:TERMUX_CONFIG_PATH, g:stdpos)', 'Open '.g:TERMUX_CONFIG_PATH],
					\ [s:reload_termux_config, '!termux-reload-settings', 'Reload '.g:TERMUX_CONFIG_PATH],
			\ ])
	endif

	" register HELP menu with weight 10000
	call quickui#menu#install(s:help_label, [
				\ [s:vim_cheatsheet, 'help index', ''],
				\ [s:exnvim_cheatsheet."\tLEAD ?", 'ExNvimCheatSheet', 'extra.nvim cheatsheet'],
				\ [s:tips, 'help tips', ''],
				\ ['--',''],
				\ [s:tutorial, 'help tutor', ''],
				\ [s:quick_reference, 'help quickref', ''],
				\ [s:summary, 'help summary', ''],
				\ ['--',''],
				\ [s:intro_screen."\t:intro", 'intro', 'Show intro message'],
				\ [s:vim_version."\t:ver", 'version', 'Show Vim version'],
				\ ], 10000)
endfunction

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

call ChangeLanguage()

" hit space twice to open menu
noremap <space><space> <cmd>call ChangeNames()<cr><cmd>call RebindMenus()<cr><cmd>call quickui#menu#open()<cr>
