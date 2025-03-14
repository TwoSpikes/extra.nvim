augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
        \ let s:line = line("'\"")
        \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
        \      && index(['xxd', 'gitrebase'], &filetype) == -1
        \ |   execute "normal! g`\""
        \ | endif
augroup END

augroup SaveFiletype
	autocmd!
	autocmd BufLeave * let g:prev_filetype=&filetype
augroup END

augroup ExNvimOptionsInComment
	autocmd!
	autocmd BufEnter * if v:vim_did_enter|call HandleExNvimOptionsInComment()|endif
augroup END

augroup on_resized
	autocmd!
	autocmd VimResized * mode
augroup END

augroup colorscheme_manage
	autocmd!
	function! ColorSchemeManagePre()
		if exists('g:cursorline_style_supported')
			if exists('g:cursorline_style')
				let g:cursorline_style = g:cursorline_style_supported[g:cursorline_style]
			endif
			unlet g:cursorline_style_supported
			if exists('g:updating_cursorline_supported')
				unlet g:updating_cursorline_supported
			endif
		endif
		if exists('g:updating_cursor_style_supported')
			unlet g:updating_cursor_style_supported
		endif
	endfunction
augroup END
augroup exnvim_colorscheme
	autocmd!
	autocmd ColorSchemePre * call ColorSchemeManagePre()
augroup END

augroup exnvim_numbertoggle
	autocmd!
	autocmd ModeChanged *:[vV\x16]* call Numbertoggle('v')
	autocmd ModeChanged [vV\x16]*:* call Numbertoggle(mode())
augroup END
function! DefineAugroupNumbertoggle()
	augroup numbertoggle
		autocmd!
		if g:linenr
			autocmd InsertLeave * call Numbertoggle('')
			autocmd InsertEnter * call Numbertoggle(v:insertmode)
			autocmd ModeChanged *:Rv call AbsNu('v')
			autocmd BufReadPost,BufEnter,BufLeave,WinLeave,WinEnter * call Numbertoggle()
			autocmd FileType lazy,spectre_panel,man,pkgman call Numbertoggle()|call HandleBuftype(winnr())
		else
			autocmd! numbertoggle
		endif
	augroup END
endfunction
call DefineAugroupNumbertoggle()

augroup netrw
	autocmd!
	autocmd filetype netrw setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup neo-tree
	autocmd!
	autocmd filetype neo-tree setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup terminal
	autocmd!
	if has('nvim')
		autocmd termopen * setlocal nocursorline nocursorcolumn | call NoNu()
	endif
augroup END
augroup visual
	function! HandleBuftype(winnum)
		let filetype = getwinvar(a:winnum, '&filetype', 'ERROR')
		let buftype = getwinvar(a:winnum, '&buftype', 'ERROR')

		let pre_cursorcolumn = (mode() !~# "[vVirco]" && mode() !~# "\<c-v>") && !g:fullscreen && filetype !=# 'netrw' && buftype !=# 'terminal' && filetype !=# 'neo-tree' && buftype !=# 'nofile'
		let pre_cursorcolumn = pre_cursorcolumn && g:cursorcolumn
		call setwinvar(a:winnum, '&cursorcolumn', pre_cursorcolumn)

		let pre_cursorline = !g:fullscreen
		if exists('g:cursorline_style_supported') && g:cursorline_style_supported[g:cursorline_style] ==# "reverse"
			let pre_cursorline = pre_cursorline && mode() !~# "[irco]"
			let pre_cursorline = pre_cursorline && (buftype !=# 'nofile' || filetype ==# 'neo-tree') && filetype !=# 'TelescopePrompt' && filetype !=# 'spectre_panel' && filetype !=# 'lazy' && filetype !=# 'pkgman'
		endif
		let pre_cursorline = pre_cursorline && buftype !=# 'terminal' && filetype !=# 'alpha' && filetype !=# "notify"
		let pre_cursorline = pre_cursorline && g:cursorline
		call setwinvar(a:winnum, '&cursorline', pre_cursorline)
	endfunction
augroup END
augroup exnvim_handle_buftype
	autocmd!
	autocmd ModeChanged,BufWinEnter * call HandleBuftype(winnr())
augroup END
call HandleBuftype(winnr())

function! OpenWithXdg(filename)
	if !PluginExists('vim-quickui')
		echohl Question
		if g:language ==# 'russian'
			echon 'Открыть через xdg-open (y/N): '
		else
			echon 'Open with xdg-open (y/N): '
		endif
		echohl Normal
		let choice = nr2char(getchar())
	else
		if g:language ==# 'russian'
			let choice = quickui#confirm#open('Открыть через xdg-open?', "&Да\n&Отмена", 1, 'Confirm')
		else
			let choice = quickui#confirm#open('Open with xdg-open?', "&OK\n&Cancel", 1, 'Confirm')
		endif
		if choice ==# 1
			let choice = 'y'
		elseif choice ==# 2
			let choice = 'n'
		else
			let choice = 'n'
		endif
	endif
	if choice ==# 'y'
	\&&executable('xdg-open') ==# 1
		execute "!xdg-open -- ".a:filename
	endif
endfunction
augroup xdg_open
	autocmd!
	autocmd BufEnter *.jpg,*.png,*.jpeg,*.bmp if v:vim_did_enter | call OpenWithXdg(Repr_Shell(expand('%'))) | endif
augroup END

augroup UnfocusFiletype
	autocmd!
	autocmd BufWinEnter * if &filetype==#'notify'|wincmd p|endif
augroup END

if v:version >= 700
  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

augroup exnvim_gitbranch
	autocmd!
	autocmd BufEnter,BufLeave * call SetGitBranch()
augroup END

let g:exnvim_fully_loaded += 1
