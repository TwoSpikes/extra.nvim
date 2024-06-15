if $TERMUX_VERSION == ""
	if $DISPLAY == ""
		let g:XkbSwitchEnabled = 0
	else
		let g:XkbSwitchEnabled = 1
	endif
else
 	set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
" 	set keymap=russian-jcukenwin
endif
