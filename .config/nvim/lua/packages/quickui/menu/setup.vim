if !has('nvim') || !PluginExists('vim-quickui')
	finish
endif

function! ChangeLanguageQuickuiMenuCallProperFunction(function_name_base)
	let language = SelectFallbackLanguage({
		\ lang -> exists('*'.a:function_name_base.lang)
		\ })
	let function_name = a:function_name_base.language
	call call(function_name, [])
endfunction

function! ChangeLanguageQuickuiMenu(namespace_name='system', language=g:language)
	if !exists('*RebindMenus_'.a:namespace_name)
		echohl ErrorMsg
		echomsg "extra.nvim: ChangeLanguageQuickuiMenu: no such namespace: ".a:namespace_name
		echohl Normal
		return
	endif

	let function_name_base = 'ChangeLanguageQuickuiMenu_'.a:namespace_name

	if exists('*'.function_name_base)
		call call(function_name_base, [])
	endif

	let function_name_base .= '_'
	call ChangeLanguageQuickuiMenuCallProperFunction(function_name_base)
	unlet function_name_base
endfunction

function! ChangeLanguageQuickuiMenuCommon()
	call ChangeLanguageQuickuiMenuCallProperFunction('ChangeLanguageQuickuiMenuCommon_')
endfunction

function! ChangeLanguageQuickuiMenuCommon_english()
	if g:exnvim_mapleader ==# ' '
		let s:leader_label = 'SPC '
	elseif g:exnvim_mapleader ==# "\b"
		let s:leader_label = 'BS '
	elseif g:exnvim_mapleader ==# "\e"
		let s:leader_label = 'ESC '
	elseif g:exnvim_mapleader ==# "\f"
		let s:leader_label = 'FF '
	elseif g:exnvim_mapleader ==# "\n"
		let s:leader_label = 'NL '
	elseif g:exnvim_mapleader ==# "\r"
		let s:leader_label = 'CR '
	elseif g:exnvim_mapleader ==# "\t"
		let s:leader_label = 'TAB '
	elseif g:exnvim_mapleader ==# "\013"
		let s:leader_label = 'VT '
	else
		let s:leader_label = g:exnvim_mapleader
	endif
endfunction

function! ChangeLanguageQuickuiMenuCommon_russian()
	if g:exnvim_mapleader ==# ' '
		let s:leader_label = 'ПРБ '
	elseif g:exnvim_mapleader ==# "\b"
		let s:leader_label = 'БЭК '
	elseif g:exnvim_mapleader ==# "\e"
		let s:leader_label = 'ВЫХ '
	elseif g:exnvim_mapleader ==# "\f"
		let s:leader_label = 'ПФ '
	elseif g:exnvim_mapleader ==# "\n"
		let s:leader_label = 'НС '
	elseif g:exnvim_mapleader ==# "\r"
		let s:leader_label = 'ВК '
	elseif g:exnvim_mapleader ==# "\t"
		let s:leader_label = 'ТАБ '
	elseif g:exnvim_mapleader ==# "\013"
		let s:leader_label = 'ВТ '
	else
		let s:leader_label = g:exnvim_mapleader
	endif
endfunction

function! ChangeLanguageQuickuiMenu_system()
	if mode() !~# '^n'
		let s:esc_command = 'exec "normal! \<c-\>\<c-n>"'
	else
		if exists('g:Vm') && g:Vm['buffer'] !=# 0
			let s:esc_command = b:VM_Selection.Vars.noh."call vm#reset()"
		elseif @/ !=# ""
			let s:esc_command = 'let @/ = ""'
		else
			let s:esc_command = "normal! \<esc>"
		endif
	endif
endfunction

function! ChangeLanguageQuickuiMenu_system_english()
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
	let s:update_plugins_label = 'U&pdate plugins'
	let s:update_coc_label = 'Update &coc servers'
	let s:update_treesitter_label = 'Update &TreeSitter'
	let s:download_plugins_label = 'Download pl&ugins'
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
	let s:recently_opened_files_label = 'Recentl&y opened files'
	let s:make_window_only_label = '&Make window only'
	let s:previous_window_label = '&Previous window'
	let s:next_window_label = '&Next window'
	let s:horizontally_split_label = 'Hor&izontally split'
	let s:vertically_split_label = '&Vertically split'
	let s:open_terminal_label = '&Open terminal'
	let s:open_terminal_in_current_file_dir_label = 'Terminal in curr&.file dir'
	let s:open_terminal_program_label = 'Op&en terminal program'
	let s:open_in_current_file_dir_label = 'Open in curr&-t file dir'
	let s:cd_into_current_file_dir_label = 'c&d into curr-t file dir'
	let s:open_far_mc_label = 'Open Far/M&c'
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
	let s:show_git_modified_label = 'Modified &Git files'

	let s:option_label = '&Option'
	let s:set_spell = 'Set &Spell'
	let s:set_paste = 'Set &Paste'
	let s:set_cursor_column = 'Set Cursor &Column'
	let s:set_cursor_line = 'Set Cursor L&ine'
	let s:cursor_line_style = 'C&ursor line style'
	let s:set_line_numbers = 'Set Line &numbers'
	let s:line_numbers_style_label = 'Line numbers &style'
	let s:show_pair_brackets_label = 'Show p&air brackets'

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
	if mode() !~# '^n'
		let s:esc_label = "Go to No&rmal mode"
	else
		if exists('g:Vm') && g:Vm['buffer'] !=# 0
			let s:esc_label = "Exit multicu&rsor"
		elseif @/ !=# ""
			let s:esc_label = "Stop sea&rching"
		else
			let s:esc_label = "Stop cu&rrent command"
		endif
	endif
endfunction

function! ChangeLanguageQuickuiMenu_system_russian()
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
	let s:update_coc_label = "Обновить &coc lsp'ы"
	let s:update_treesitter_label = 'Обновить &TreeSitter'
	let s:download_plugins_label = '&u:Скачать плагины'
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
	let s:open_file_in_buffer_label = '&b:Открыть файл в буффере'
	let s:toggle_file_tree_label = '&f:Переключ.дерево файлов'
	let s:telescope_fuzzy_find_label = '&z:Поиск Telescope'
	let s:open_file_using_ranger_label = '&r:Открыть файл в ranger'
	let s:recently_opened_files_label = '&y:Недавно открытые файлы'
	let s:make_window_only_label = '&m:Закрыть остальные окна'
	let s:previous_window_label = '&p:Предыдущее окно'
	let s:next_window_label = '&n:Следующее окно'
	let s:horizontally_split_label = '&i:Горизонтальный сплит'
	let s:vertically_split_label = '&v:Вертикальный сплит'
	let s:open_terminal_label = '&o:Открыть терминал'
	let s:open_terminal_in_current_file_dir_label = 'Терминал в директ&.текущ.файла'
	let s:open_terminal_program_label = '&e:Откр.прог.в терминале'
	let s:open_in_current_file_dir_label = 'Откр.в дир&-и текущ.файла'
	let s:cd_into_current_file_dir_label = 'c&d-шнуться в дир-ю тек. файла'
	let s:open_far_mc_label = 'Открыть Far/M&c'
	let s:open_lazygit_label = 'Открыть lazy&git'
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
	let s:show_git_modified_label = 'Модифицированные &Git файлы'

	let s:option_label = '&o:Опции'
	let s:set_spell = '&s:Проверка орфографии'
	let s:set_paste = '&p:Режим вставки'
	let s:set_cursor_column = '&c:Подсветка колонки'
	let s:set_cursor_line = '&i:Подсветка линии'
	let s:cursor_line_style = '&u:Стиль подсветки линии'
	let s:set_line_numbers = '&n:Номера строк'
	let s:line_numbers_style_label = '&s:Стиль номеров строк'
	let s:show_pair_brackets_label = '&a:Показать парные скобки'

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
	if mode() !~# '^n'
		let s:esc_label = "&r:Выйти в нормальный режим"
	else
		if exists('g:Vm') && g:Vm['buffer'] !=# 0
			let s:esc_label = "&r:Выйти из мультикурсора"
		elseif @/ !=# ""
			let s:esc_label = "&r:Остановить поиск"
		else
			let s:esc_label = "&r:Останов.текущ.команду"
		endif
	endif
endfunction

function! ChangeLanguageQuickuiMenu_system_komi()
	let s:off = 'Кус.'
	let s:on = 'Пырт.'
	let s:disable = 'Кусӧдны'
	let s:enable = 'Пыртны'
	let s:make_relative = 'рӧдвуж'
	let s:make_absolute = 'абсолютнӧй'

	let s:file_label = '&f:Файл'
	let s:new_file_label = '&w:Выль файл'
	let s:close_label = '&o:Пӧдлавны'
	let s:force_close_label = '&e:Матын ставӧн'
	let s:save_label = '&s:Видзны'
	let s:save_all_label = '&a:Ставсö видзны'
	let s:save_as_label = '&v:Видзны кыдзи'
	let s:save_as_and_edit_label = '&i:Видзны кыдзи да пыртны'
	let s:update_plugins_label = '&p:Выльмӧдны плагинъяс'
	let s:update_coc_label = "Выльмöдны &coc lsp"
	let s:update_treesitter_label = 'Выльмöдны &TreeSitter'
	let s:download_plugins_label = '&u:Скачайтны плагинъяс'
	let s:redraw_screen_label = '&n:Перерисуйтны экран'
	let s:hide_highlightings_label = '&d:Дзебны выделение'
	let s:toggle_fullscreen_label = '&f:Тыр экран режим'
	let s:exit_label = '&x:Петны'
	let s:exit_wo_confirm_label = '&m:Петны ставӧн'

	let s:window_label = '&w:Öшинь'
	let s:kill_buffer_label = '&u:Кулöм буфер'
	let s:select_buffer_label = '&s:Бöрйы буфер'
	let s:search_word_using_spectre_label = '&w:Корсьны кыв Spectre'
	let s:open_file_in_tab_label = '&t:Восьтыны файл выль вкл.'
	let s:open_file_in_buffer_label = '&b:Восьтыны буферын файл'
	let s:toggle_file_tree_label = '&f:Переключатель файл пу'
	let s:telescope_fuzzy_find_label = '&z:Корсьны Telescope''ын'
	let s:open_file_using_ranger_label = '&r:Восьтыны файл ranger''ын'
	let s:recently_opened_files_label = '&y:Неважӧн восьтӧм файлӧвӧй'
	let s:make_window_only_label = '&m:Мукӧд ӧшиньяс ӧшӧдны'
	let s:previous_window_label = '&p:Воддза ӧшинь'
	let s:next_window_label = '&n:Мӧд ӧшинь'
	let s:horizontally_split_label = '&i:Горизонтальнӧй юкӧм'
	let s:vertically_split_label = '&v:Вертикальнӧй торъялӧм'
	let s:open_terminal_label = '&o:Восьса терминал'
	let s:open_terminal_in_current_file_dir_label = 'Терминал ӧнія файл катал&.'
	let s:open_terminal_program_label = '&e:Восьтыны прогр.терминалын'
	let s:open_in_current_file_dir_label = 'Восьтыны ӧнія файл кат&-ын'
	let s:cd_into_current_file_dir_label = 'c&d каталогын ӧнія файл'
	let s:open_far_mc_label = 'Восьса Far/M&c'
	let s:open_lazygit_label = 'Восьса lazy&git'
	let s:open_start_menu_label = '&a:Восьтыны шӧр меню'

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
	let s:show_git_modified_label = 'Модифицированные &Git файлы'

	let s:option_label = '&o:Вариантъяс'
	let s:set_spell = '&s:Проверка орфографии'
	let s:set_paste = '&p:Режим вставки'
	let s:set_cursor_column = '&c:Подсветка колонки'
	let s:set_cursor_line = '&i:Подсветка линии'
	let s:cursor_line_style = '&u:Стиль подсветки линии'
	let s:set_line_numbers = '&n:Номера строк'
	let s:line_numbers_style_label = '&s:Стиль номеров строк'
	let s:show_pair_brackets_label = '&a:Показать парные скобки'

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

	let s:help_label = '&h:Отсöг'
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
	if mode() !~# '^n'
		let s:esc_label = "&r:Выйти в нормальный режим"
	else
		if exists('g:Vm') && g:Vm['buffer'] !=# 0
			let s:esc_label = "&r:Выйти из мультикурсора"
		elseif @/ !=# ""
			let s:esc_label = "&r:Остановить поиск"
		else
			let s:esc_label = "&r:Останов.текущ.команду"
		endif
	endif
endfunction

function! ChangeLanguageQuickuiMenu_extra_english()
	let s:extra_label = 'E&xtra'
	let s:toggle_pager_mode_label = 'Toggle &pager mode'
	let s:toggle_soft_wrap_label = 'Toggle soft &wrap'

	let s:tools_label = '&Tools'
	let s:search_anime_label = '&Search anime'
	let s:watch_anime_from_history_label = '&Watch anime from history'
	let s:invert_pdf_label = 'Invert &pdf'
endfunction

function! ChangeLanguageQuickuiMenu_extra_russian()
	let s:extra_label = '&x:Дополнительно'
	let s:toggle_pager_mode_label = 'Переключ.режим &pager''а'
	let s:toggle_soft_wrap_label = '&w:Перекл.перенос по словам'

	let s:tools_label = '&t:Инструменты'
	let s:search_anime_label = '&s:Искать аниме'
	let s:watch_anime_from_history_label = '&w:Смотреть аниме из истории'
	let s:invert_pdf_label = 'Инвертировать &pdf'
endfunction

function! RebindMenus(namespace_name='system')
	call quickui#menu#switch(a:namespace_name)

	" clear all the menus
	call quickui#menu#reset()

	let function_name = 'RebindMenus_'.a:namespace_name

	if !exists('*'.function_name)
		echohl ErrorMsg
		echomsg "extra.nvim: RebindMenus: no such namespace: ".a:namespace_name
		echohl Normal
		return
	endif

	call call(function_name, [])
endfunction

function! RebindMenus_system()
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
					\ [(g:quickui_icons?"󰳻 ":"").s:save_as_label."\t".s:leader_label.'Ctrl-s', 'call SaveAs()', 'Save current file as ...' ],
					\ ])
	endif
	if exists(':SaveAsAndRename')
		call quickui#menu#install(s:file_label, [
					\ [(g:quickui_icons?"󰳻 ":"").s:save_as_and_edit_label."\t".s:leader_label.'Ctrl-r', 'call SaveAsAndRename()', 'Save current file as ... and edit it' ],
					\ ])
	endif
	call quickui#menu#install(s:file_label, [
				\ ["--", ''],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_plugins_label."\t".s:leader_label.'up', 'PlugUpdate', 'Update plugins using "vim-plug"'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_coc_label."\t".s:leader_label.'uc', 'CocUpdate', 'Update coc.nvim installed language servers'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_treesitter_label."\t".s:leader_label.'ut', 'TSUpdate', 'Update installed TreeSitter parsers'],
				\ ])
	if PluginInstalled('activate')
		call quickui#menu#install(s:file_label, [
					\ [(g:quickui_icons?"󰇚 ":"").s:download_plugins_label."\t".s:leader_label.'xp', 'lua require("activate").list_plugins()', 'List plugins for download'],
					\ ])
	endif
	call quickui#menu#install(s:file_label, [
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:redraw_screen_label."\tCtrl-l", 'mode', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?" ":"").s:hide_highlightings_label."\t".s:leader_label.'d', 'nohlsearch', 'Hide search highlightings'],
				\ [(g:quickui_icons?" ":"").s:esc_label."\tesc", s:esc_command, 'Stop searching'],
				\ [(g:quickui_icons?"󰊓 ":"").s:toggle_fullscreen_label."\t".s:leader_label.'Ctrl-f', 'ToggleFullscreen', 'Toggle fullscreen mode'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_label."\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_wo_confirm_label."\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
				\ ])

	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󱂥 ":"").s:kill_buffer_label."\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
				\ [(g:quickui_icons?" ":"").s:select_buffer_label."\t".s:leader_label.'b', 'call quickui#tools#list_buffer("e")', 'Select buffer to edit in current buffer'],
				\ ])
	if executable('rg')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󱎸 ":"").s:search_word_using_spectre_label."\t".s:leader_label.'sw', 'exec "lua require(\"spectre\").open_visual({select_word = true})"', 'Select buffer to edit in current buffer'],
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
					\ [(g:quickui_icons?"󰥨 ":"").s:telescope_fuzzy_find_label."\t".s:leader_label.(g:compatible=~#'^helix'?'f':'f'), 'call FuzzyFind()', 'Opens Telescope.nvim find file'],
					\ ])
	endif
	if executable('ranger')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?" ":"").s:open_file_using_ranger_label."\t".s:leader_label.(g:compatible=~#'^helix'?'xr':'r'), 'call OpenRangerCheck()', 'Opens ranger to select file to open'],
					\ ])
	endif
	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰚰 ":"").s:recently_opened_files_label."\t".s:leader_label.'fr', 'lua require("telescope").extensions.recent_files.pick()', 'Show menu to select file from recently opened'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:make_window_only_label."\tCtrl-x 1", 'only', 'Hide all but current window'],
				\ [(g:quickui_icons?" ":"").s:previous_window_label."\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
				\ [(g:quickui_icons?" ":"").s:next_window_label."\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
				\ [(g:quickui_icons?" ":"").s:horizontally_split_label."\tCtrl-x 2", 'split', 'Horizontally split current window'],
				\ [(g:quickui_icons?" ":"").s:vertically_split_label."\tCtrl-x 3", 'vsplit', 'Vertically split current window'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:open_terminal_label."\t".s:leader_label.'.', 'call SelectPosition("", g:termpos)', 'Opens a terminal'],
				\ [(g:quickui_icons?" ":"").s:open_terminal_in_current_file_dir_label."\t".s:leader_label.'%', 'call SelectPosition("", g:termpos, fnamemodify(expand("%:p"), ":h"))', 'Opens a terminal program in current file''s directory'],
				\ [(g:quickui_icons?" ":"").s:open_terminal_program_label."\t".s:leader_label.'x.', 'call OpenTermProgram()', 'Opens a terminal program'],
				\ [(g:quickui_icons?" ":"").s:open_in_current_file_dir_label."\t".s:leader_label.'x%', 'call OpenTermProgram(fnamemodify(expand("%:p"), ":h"))', 'Opens a terminal program in current file''s directory'],
				\ [(g:quickui_icons?"󱧮 ":"").s:cd_into_current_file_dir_label."\t".s:leader_label.'<R>', 'call chdir(fnamemodify(expand("%:p"), ":h"))|pwd', 'Change directory to current file''s directory'],
				\ ])
	if v:false
	\|| executable('mc')
	\|| executable('far')
	\|| executable('far2l')
	\|| executable('lazygit')
	\|| PluginInstalled('alpha')
		call quickui#menu#install(s:window_label, [
				\ ["--", ''],
			  \ ])
	endif
	if executable('mc') || executable('far') || executable('far2l')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"").s:open_far_mc_label."\t".s:leader_label.'m', 'call SelectPosition(g:far_or_mc, g:termpos)', 'Opens Far or Midnight commander'],
				\ ])
	endif
	if executable('lazygit')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"").s:open_lazygit_label."\t".s:leader_label.'xz', 'call SelectPosition("lazygit", g:termpos)', 'Opens Lazygit'],
				\ ])
	endif
	if PluginInstalled('alpha')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰍜 ":"").s:open_start_menu_label."\t".s:leader_label.'A', 'call RunAlphaIfNotAlphaRunning()', 'Opens alpha-nvim menu'],
				\ ])
	endif

	" items containing tips, tips will display in the cmdline
	" (or in the statusline if the patch was applied)
	call quickui#menu#install(s:text_label, [
				\ [(g:quickui_icons?"󰆏 ":"").s:copy_line_label."\t".(g:compatible=~#"^helix"?"xy":"yy"), 'yank', 'Copy the line where cursor is located'],
				\ [(g:quickui_icons?"󰆴 ":"").s:delete_line_label."\t".(g:compatible=~#"^helix"?"x\"_d":"sd"), 'delete x', 'Delete the line where cursor is located'],
				\ [(g:quickui_icons?"󰆐 ":"").s:cut_line_label."\t".(g:compatible=~#"^helix"?"xd":"dd"), 'delete _', 'Cut the line where cursor is located'],
				\ [(g:quickui_icons?"󰆒 ":"").s:paste_after_label."\tp", 'normal! p', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?"󰆒 ":"").s:paste_before_label."\tP", 'normal! P', 'Paste copyied text before the cursor'],
				\ [(g:quickui_icons?"  ":"").s:join_lines_label."\tJ", 'join', 'Join current and next line and put between them a space'],
				\ [(g:quickui_icons?"  ":"").s:force_join_lines_label."\tgJ", 'normal! p', 'Join current and next line and leave blanks as it is'],
				\ ["--", ''],
				\ [(g:quickui_icons?" ":"").s:forward_find_whole_word_label."\t".(g:compatible=~#"^helix_hard"?"eb*":"*"), 'normal! *', 'Forwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"").s:backward_find_whole_word_label."\t".(g:compatible=~#"^helix_hard"?"eb#":"#"), 'normal! #', 'Backwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"").s:forward_find_word_label."\t".(g:compatible=~#"^helix_hard"?"ebg*":"g*"), 'normal! g*', 'Forwardly find word under cursor'],
				\ [(g:quickui_icons?" ":"").s:backward_find_word_label."\t".(g:compatible=~#"^helix_hard"?"ebg#":"g#"), 'normal! g#', 'Backwardly find word under cursor'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰅺 ":"").s:comment_out_label."\t".s:leader_label.'c', 'call '.(mode() =~# '^n'?'N':'X').'_CommentOutDefault()', 'Comment out line under cursor'],
				\ [(g:quickui_icons?"󱗡 ":"").s:uncomment_out_label."\t".s:leader_label.'C', 'call '.(mode() =~# '^n'?'N':'X').'_UncommentOutDefault()', 'Uncomment line under cursor'],
				\ ["--", ''],
				\ [(g:quickui_icons?"󰗧 ":"").s:go_to_multicursor_mode_label."\tCtrl-n", 'call vm#commands#ctrln(1)', 'Go to multicursor mode'],
				\ [(g:quickui_icons?" ":"").s:show_hlgroup_label."", 'call SynGroup()', 'Show hlgroup name under cursor'],
				\ [(g:quickui_icons?" ":"").s:whence_hlgroup_label, 'call WhenceGroup()', 'Show whence hlgroup under cursor came'],
				\ [(g:quickui_icons?"󰒆 ":"").s:select_all_label."\t".(g:compatible=~#"^helix"?"%":"Ctrl-x h"), 'call SelectAll()', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?" ":"").s:toggle_tagbar_label."\tCtrl-t", 'TagbarToggle', 'Toggles tagbar'],
				\ [(g:quickui_icons?" ":"").s:generate_annotation_label."\t".s:leader_label.'n', 'Neogen', 'Generate Neogen annotation (:h neogen)'],
				\ ])

	call quickui#menu#install(s:lsp_label, [
				\ ["Coc &previous diagnostic\t[g", 'call CocActionAsync("diagnosticPrevious")', 'Go to previous diagnostic'],
				\ ["Coc &next diagnostic\t]g", 'call CocActionAsync("diagnosticNext")', 'Go to next diagnostic'],
				\ ["Go to &definition\tgd", 'call CocActionAsync("jumpDefinition")', 'Jump to definition'],
				\ ["Go to &type definition\tgy", 'call CocActionAsync("jumpTypeDefinition")', 'Jump to type definition'],
				\ ["Go to &implementation\tgi", 'call CocActionAsync("jumpImplementation")', 'Jump to implementation'],
				\ ["G&o to references\tgr", 'call CocActionAsync("jumpReferences")', 'Jump to references'],
				\ ["--", '' ],
				\ ["Code &actions selected\t".s:leader_label.'a', 'call CocActionAsync("codeAction", visualmode())', 'Apply code actions for selected code'],
				\ ["Code actions &cursor\t".s:leader_label.'ac', 'call CocActionAsync("codeAction", "cursor")', 'Apply code actions for current cursor position'],
				\ ["Code actions &buffer\t".s:leader_label.'as', 'call CocActionAsync("codeAction", "", ["source"], v:true)', 'Apply code actions for current buffer'],
				\ ["Fi&x current line\t".s:leader_label.'qf', 'call CocActionAsync("doQuickfix")', 'Apply the most preferred quickfix action to fix diagnostic on the current line'],
				\ ["--", '' ],
				\ ["&Refactor\t".s:leader_label.'Re', 'call CocActionAsync("codeAction", "cursor", ["refactor"], v:true)', 'Codeaction refactor cursor'],
				\ ["Refactor s&elected\t".s:leader_label.'R', 'call CocActionAsync("codeAction", visualmode(), ["refactor"], v:true)', 'Codeaction refactor selected'],
				\ ["--", '' ],
				\ ["C&ode lens current line\t".s:leader_label.'cl', 'call CocActionAsync("codeLensAction")', 'Run the Code Lens action on the current line'],
				\ ["&Show documentation\tK", 'call ShowDocumentation()', 'Show documentation in preview window'],
				\ ["Rename s&ymbol\t".s:leader_label.'rn', 'call CocActionAsync("rename")', 'Rename symbol under cursor'],
				\ ["&Format selected\t".s:leader_label.'f', 'call CocActionAsync("formatSelected", visualmode())', 'Format selected code'],
				\ ["Fold c&urrent buffer\t:Fold", 'Fold', 'Make folds for current buffer'],
				\ ])

	if has('nvim') && PluginExists('vim-fugitive')
		call quickui#menu#install(s:git_label, [
				\ ["&Commit\t".s:leader_label.'gc', 'Git commit --verbose', 'Commit using fugitive.vim'],
				\ ["Commit &all\t".s:leader_label.'ga', 'Git commit --verbose --all', 'Commit all using fugitive.vim'],
				\ ["Commit a&mend\t".s:leader_label.'gA', 'Git commit --verbose --amend', 'Amend commit using fugitive.vim'],
				\ ["--", ''],
				\ ["P&ull\t".s:leader_label.'gp', 'Git pull', 'Pull repository using fugitive.vim'],
				\ ["&Push\t".s:leader_label.'gP', 'Git push', 'Push repository using fugitive.vim'],
				\ ["&Reset soft\t".s:leader_label.'gr', 'Git reset --soft', 'Reset repository using fugitive.vim'],
				\ ["Reset har&d\t".s:leader_label.'gh', 'Git reset --hard', 'Hardly reset repository using fugitive.vim'],
				\ ["Reset mi&xed\t".s:leader_label.'gm', 'Git reset --mixed', 'Mixed reset repository using fugitive.vim'],
				\ ["--", ''],
				\ ["&Status\t".s:leader_label.'gs', 'Git status', 'Show repository status using fugitive.vim'],
				\ ["&Init\t".s:leader_label.'gi', 'Git init', 'Initialize empty Git repository'],
				\ ])
	endif
	if has('nvim') && PluginExists('diffview.nvim')
		call quickui#menu#install(s:git_label, [
				\ ["&View diff\t".s:leader_label.'gd', 'DiffviewOpen HEAD', 'Show diff'],
				\ ])
	endif
	if has('nvim') && PluginExists('vim-fugitive')
		call quickui#menu#install(s:git_label, [
				\ ["--", ''],
				\ ["Cl&one\t".s:leader_label.'gC', 'GitClone', 'Clone a repository with specific URL'],
				\ ["Clone depth=&1\t".s:leader_label.'g1', 'GitClone --depth=1', 'Clone a repository with specific URL'],
				\ ["Clone &recursively\t".s:leader_label.'gR', 'GitClone --recursive', 'Clone a repository with specific URL'],
				\ ["Clone r&ecursively depth=1\t".s:leader_label.'g2', 'GitClone --depth=1 --recursive', 'Clone a repository with specific URL'],
				\ ])
	endif
	if has('nvim') && PluginInstalled('telescope')
		call quickui#menu#install(s:git_label, [
			\ [s:show_git_modified_label."\t".s:leader_label.'g*', 'Telescope git_status', 'Show git modified files'],
			\ ])
	endif

	call quickui#menu#install(s:option_label, [
				\ [(g:quickui_icons?"󰓆 ":"").s:set_spell." %{&spell?\"".s:off."\":\"".s:on."\"}", 'set spell!', "%{&spell?\"".s:disable."\":\"".s:enable."\"} spell checking"],
				\ [(g:quickui_icons?"󰆒 ":"").s:set_paste." %{&paste?\"".s:off."\":\"".s:on."\"}", 'set paste!', 'Obsolete thing'],
				\ ["--", ''],
				\ [(g:quickui_icons?"  ":"").s:set_cursor_column." %{g:cursorcolumn?\"".s:off."\":\"".s:on."\"}", 'let g:cursorcolumn=!g:cursorcolumn|call PreserveAndDo("call HandleBuftypeAll()")', "%{g:cursorcolumn?\"".s:disable."\":\"".s:enable."\"} current column highlighting"],
				\ [(g:quickui_icons?"  ":"").s:set_cursor_line." %{g:cursorline?\"".s:off."\":\"".s:on."\"}", 'let g:cursorline=!g:cursorline|call PreserveAndDo("call HandleBuftypeAll()")', "%{g:cursorline?\"".s:disable."\":\"".s:enable."\"} current line highlighting"],
				\ ])
	if exists('g:cursorline_style_supported') && len(g:cursorline_style_supported) ># 1
		call quickui#menu#install(s:option_label, [
					\ [(g:quickui_icons?"  ":"").s:cursor_line_style.': %{g:cursorline_style_supported[g:cursorline_style]}', 'let g:cursorline_style=g:cursorline_style==#len(g:cursorline_style_supported)-1?0:g:cursorline_style+1|call Update_CursorLine_Style()', "%{g:cursorline?\"".s:disable."\":\"".s:enable."\"} current line highlighting"],
					\ ])
	endif
	call quickui#menu#install(s:option_label, [
				\ [(g:quickui_icons?" ":"").s:set_line_numbers." %{g:linenr?\"".s:off."\":\"".s:on."\"}", 'let g:linenr=!g:linenr|if !g:linenr|call PreserveAndDo("call NoNuAll()")|else|call PreserveAndDo("call NumbertoggleAll(mode())")|endif', "%{g:linenr?\"".s:disable."\":\"".s:enable."\"} line numbers"],
				\ [(g:quickui_icons?" ":"").s:line_numbers_style_label.': %{g:linenr_style}', 'let g:linenr_style=g:linenr_style==#"relative"?"absolute":"relative"|if g:linenr|call PreserveAndDo("call NumbertoggleAll(mode())")|endif', "Make line numbers %{g:linenr_style==#\"absolute\"?\"".s:make_relative."\":\"".s:make_absolute."\"}"],
				\ [(g:quickui_icons?"󰅲 ":"").s:show_pair_brackets_label.': %{len(&matchpairs)!=#0?"'.s:on.'":"'.s:off.'"}', 'if len(&matchpairs)!=#0|let g:old_matchpairs=&matchpairs|let &matchpairs=""|else|let &matchpairs=g:old_matchpairs|endif|doautocmd matchparen WinEnter', "Make line numbers %{g:linenr_style==#\"absolute\"?\"".s:make_relative."\":\"".s:make_absolute."\"}"],
				\ ])

	call quickui#menu#install(s:config_label, [
			\ [s:open_init_vim."\t".s:leader_label.'ve', 'call SelectPosition(stdpath("config")."/init.vim", g:stdpos)', 'Open '.stdpath('config').'/init.vim'],
			\ [s:open_plugins_list."\t".s:leader_label.'vi', 'call SelectPosition(g:PLUGINS_INSTALL_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_INSTALL_FILE_PATH],
			\ [s:open_plugins_setup."\t".s:leader_label.'vs', 'call SelectPosition(g:PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_SETUP_FILE_PATH],
			\ [s:open_lsp_settings."\t".s:leader_label.'vl', 'call SelectPosition(g:LSP_PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:LSP_PLUGINS_SETUP_FILE_PATH.' (deprecated due to coc.nvim)'],
			\ [s:open_exnvim_config."\t".s:leader_label.'vj', 'call SelectPosition(g:EXNVIM_CONFIG_PATH, g:stdpos)', 'Open '.g:EXNVIM_CONFIG_PATH],
			\ [s:open_colorschemes_dir."\t".s:leader_label.'vc', 'call SelectPosition($VIMRUNTIME."/colors", g:dirpos)', 'Open colorschemes directory'],
			\ ["--", ''],
			\ [s:reload_init_vim."\t".s:leader_label.'se', 'execute "source" stdpath("config")."/vim/exnvim/reload.vim"', 'Reload Vim/NeoVim config'],
			\ [s:reload_plugins_list."\t".s:leader_label.'si', 'execute "source ".g:PLUGINS_INSTALL_FILE_PATH', 'Install plugins in '.g:PLUGINS_INSTALL_FILE_PATH],
			\ [s:reload_plugins_setup."\t".s:leader_label.'ss', 'execute "source ".g:PLUGINS_SETUP_FILE_PATH', 'Reconfigure plugins'],
			\ [s:reload_lsp_setup."\t".s:leader_label.'sl', 'execute "source ".g:LSP_PLUGINS_SETUP_FILE_PATH', 'Reconfigure LSP plugins (deprecated due to coc.nvim)'],
			\ ["--", ''],
			\ ])
	if executable('exnvim')
		call quickui#menu#install(s:config_label, [
			\ [s:generate_exnvim_config."\t".s:leader_label.'G', 'GenerateExNvimConfig', 'Regenerate extra.nvim config'],
			\ ])
	endif
	if filereadable(g:EXNVIM_CONFIG_PATH)
		call quickui#menu#install(s:config_label, [
					\ [s:reload_exnvim_config."\t".s:leader_label.'sj', 'exec "source" stdpath("config")."/vim/exnvim/reload_config.vim"', 'Reload extra.nvim config'],
			\ ])
	endif
	if $TERMUX_VERSION !=# ""
		call quickui#menu#install(s:config_label, [
					\ ["--", ''],
					\ [s:open_termux_config, 'call SelectPosition(g:TERMUX_CONFIG_PATH, g:stdpos)', 'Open '.g:TERMUX_CONFIG_PATH],
					\ [s:reload_termux_config, '!termux-reload-settings', 'Reload '.g:TERMUX_CONFIG_PATH],
			\ ])
	endif

	call quickui#menu#install(s:help_label, [
				\ [s:vim_cheatsheet, 'help index', ''],
				\ [s:exnvim_cheatsheet."\t".s:leader_label.'?', 'ExNvimCheatSheet', 'extra.nvim cheatsheet'],
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

function! RebindMenus_extra()
	call quickui#menu#install(s:extra_label, [
			\ [s:toggle_pager_mode_label."\t".s:leader_label.'xP', 'TogglePagerMode', 'Toggle pager mode'],
			\ [s:toggle_soft_wrap_label."\t:SWrap", 'SWrap', 'Toggle soft text wrapping'],
		  \ ])

	call quickui#menu#install(s:tools_label, [
			\ [s:search_anime_label."\t".s:leader_label.'xA', 'execute "Ani" g:ani_cli_options', 'Search and watch anime'],
			\ [s:watch_anime_from_history_label."\t".s:leader_label.'xa', 'execute "Ani" "-c" g:ani_cli_options', 'Continue watching anime from history'],
			\ [s:invert_pdf_label."\t".s:leader_label.'xi', 'call InvertPdf(expand("%"))', 'Invert colors in current pdf file'],
		  \ ])
endfunction

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

function! ChangeLanguageQuickuiMenuAll()
	call ChangeLanguageQuickuiMenuCommon()
	call ChangeLanguageQuickuiMenu('system')
	call ChangeLanguageQuickuiMenu('extra')
endfunction

noremap <leader><space> <cmd>call RebindMenus()<bar>call quickui#menu#open()<cr>
noremap <leader>x<space> <cmd>call RebindMenus('extra')<bar>call quickui#menu#open()<cr>
