if exists('g:exnvim_fully_loaded') && !g:exnvim_fully_loaded
	finish
endif

execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload_config.vim'
let g:compatible = "common"

execute 'source' g:CONFIG_PATH.'/vim/compatible/common/unload/unload.vim'
let g:compatible = "empty"

call timer_stopall()

autocmd! AlphaNvim_CinnamonNvim_JK_Workaround *
augroup! AlphaNvim_CinnamonNvim_JK_Workaround
if has('nvim')
	autocmd! exnvim_term_closed *
	augroup! exnvim_term_closed
endif
delfunction AfterSomeEvent
if has('nvim')
	delfunction ChangeLanguageQuickuiMenu_system_english
	delfunction ChangeLanguageQuickuiMenu_system_russian
	delfunction ChangeLanguageQuickuiMenu_system_komi
	delfunction ChangeLanguageQuickuiMenu_system
	delfunction ChangeLanguageQuickuiMenu_extra_english
	delfunction ChangeLanguageQuickuiMenu_extra_russian
	delfunction ChangeLanguageQuickuiMenu_extra_komi
	delfunction ChangeLanguageQuickuiMenu_extra
	delfunction ChangeLanguageQuickuiMenu
	delfunction ChangeLanguageQuickuiMenuAll
	delfunction ChangeLanguageQuickuiMenuCallProperFunction
	delfunction ChangeLanguageQuickuiMenuCommon
	delfunction ChangeLanguageQuickuiMenuCommon_english
	delfunction ChangeLanguageQuickuiMenuCommon_russian
	delfunction ChangeLanguage
	unmap <leader><leader>
endif
autocmd! exnvim_colorscheme *
augroup! exnvim_colorscheme
delfunction ColorSchemeManagePre
delfunction ColorTable
delfunction Contains
delfunction CopyHighlightGroup
delfunction DefineAugroupNumbertoggle
delfunction Defone
delfunction DisablePagerMode
delfunction DoCommentOutDefault
delfunction Do_N_Tilde
delfunction Do_V_Tilde
delfunction DotfilesCommit
delfunction EnablePagerMode
delfunction EndsWith
delfunction ExNvimCheatSheet
delfunction ExNvimCommit
delfunction FarOrMc
if exists('*Pad')
	unmap <c-c>c
	delcommand Findfile
	delfunction Findfile
	unmap <c-c>C
	delcommand Findfilebuffer
	delfunction Findfilebuffer
endif
autocmd! exnvim_fix_sha_da *
augroup! exnvim_fix_sha_da
delfunction FixShaDa
delfunction FuzzyFind
delfunction GenerateExNvimConfig
delfunction GenerateTemporaryAutocmd
set stl=
delfunction GetRandomName
delfunction GetVisualSelection
delcommand GitClone
delfunction GitClone
autocmd! exnvim_handle_buftype *
augroup! exnvim_handle_buftype
delfunction HandleBuftype
delfunction HandleBuftypeAll
delfunction HandleExNvimConfig
delfunction HandleKeystroke
delfunction IfOneWinDo
delfunction IfNotOneWinDo
delfunction InitPlug
delcommand InvertPdf
delfunction InvertPdf
if exists('*IsHighlightGroupDefined')
	delfunction IsHighlightGroupDefined
endif
delfunction IsNo
delfunction IsYes
delfunction JKWorkaround
if exists('*JKWorkaroundAlpha')
	delfunction JKWorkaroundAlpha
endif
delfunction Killbuffer
delfunction LoadExNvimConfig
delfunction LoadVars
delfunction MakeThingsThatRequireBeDoneAfterPluginsLoaded
set tabline=
delfunction MyTabLabel
delfunction MyTabLine
delfunction N_CommentOut
delfunction N_CommentOutDefault
delfunction N_Comment_Move_Left
delfunction N_Comment_Move_Right
delfunction N_UncommentOut
delfunction N_UncommentOutDefault
autocmd! numbertoggle *
augroup! numbertoggle
autocmd! neo-tree *
augroup! neo-tree
autocmd! netrw *
augroup! netrw
autocmd! exnvim_numbertoggle *
augroup! exnvim_numbertoggle
delfunction Numbertoggle
delfunction NumbertoggleAll
delfunction Numbertoggle_AbsNu
delfunction Numbertoggle_RelNu
delfunction OnFirstTime
autocmd! exnvim_vim_leave *
augroup! exnvim_vim_leave
delfunction OnQuit
delfunction OnQuitDisable
delfunction OnStart
delfunction OpenOnStart
delfunction OpenRanger
delfunction OpenRangerCheck
delfunction OpenTerm
delfunction OpenTermProgram
autocmd! xdg_open *
augroup! xdg_open
delfunction OpenWithXdg
delfunction Pad
if exists('*Pad_middle')
	delfunction Pad_middle
endif
delfunction PluginDelete
delfunction SelectPosition
delcommand SaveAs
delcommand SaveAsAndRename
delfunction SaveAs
delfunction SaveAsAndRename
delfunction SaveAsBase
delcommand Killbuffer
delfunction SelectFallbackLanguage
delfunction PrePad
delfunction PreserveAndDo
if PluginExists('vim-quickui')
	delfunction RebindMenus_system
	delfunction RebindMenus
endif
delfunction RedefineProcessGBut
delfunction RehandleExNvimConfig
delfunction Remove
delfunction Repr_Shell
delfunction Repr_Vim_Grep
delfunction RestoreCursorFix
delfunction ReturnHighlightTerm
delfunction RunAlphaIfNotAlphaRunning
delfunction AbsNu
delfunction NoNu
delfunction NoNuAll
nunmap k
ounmap k
vunmap k
delfunction ProcessGBut
delfunction RelNu
delfunction SaveVars
delfunction Save_WW_and_Do
delfunction SelectAll
delfunction SetDefaultValuesForStartupOptionsAndExNvimConfigOptions
delfunction SetExNvimConfigPath
autocmd! exnvim_gitbranch *
augroup! exnvim_gitbranch
delfunction SetGitBranch
delfunction SetMouse
delfunction SetTermuxConfigPath
delcommand ShFunction
delfunction ShFunction
delcommand ShRun
delfunction ShRun
delcommand ShSource
delfunction ShSource
autocmd! exnvim_setmodetoshow *
augroup! exnvim_setmodetoshow
delfunction SetModeToShow
delfunction Showtab
delfunction StartsWith
delfunction SynGroup
delfunction SynStack
delfunction TermRunning
delfunction TermuxLoadCursorStyle
delfunction TermuxSaveCursorStyle
delcommand ToggleFullscreen
delfunction ToggleFullscreen
delcommand TogglePagerMode
delfunction TogglePagerMode
delfunction Trim
if exists('*Update_CursorLine')
	delfunction Update_CursorLine
endif
if exists('*Update_CursorLine_Style')
	delfunction Update_CursorLine_Style
endif
if exists('*Update_Cursor_Style')
	delfunction Update_Cursor_Style
endif
if exists('*Update_Cursor_Style_wrapper')
	delfunction Update_Cursor_Style_wrapper
endif
delfunction WhenceGroup
delfunction X_CommentOut
delfunction X_CommentOutDefault
delfunction X_Comment_Move_Left
delfunction X_Comment_Move_Right
delfunction X_UncommentOut
delfunction X_UncommentOutDefault

delcommand DotfilesCommit
delcommand ExNvimCheatSheet
delcommand ExNvimCommit
if filereadable(g:CONFIG_PATH.'/vim/xterm-color-table.vim')
	delcommand Exct
	delcommand Oxct
	delcommand Sxct
	delcommand Txct
	delcommand Vxct
endif
delcommand GenerateExNvimConfig
delcommand Md
delcommand Rm
delcommand SWrap
delcommand Showtab
delcommand Write

autocmd! RestoreCursor *
augroup! RestoreCursor

delfunction PluginInstalled
delfunction PluginExists

unlet g:CONFIG_ALREADY_LOADED
if exists('g:exnvim_fully_loaded')
	unlet g:exnvim_fully_loaded
endif
unlet g:exnvim_config
if exists('g:exnvim_sh_funcs')
	unlet g:exnvim_sh_funcs
endif
unlet g:compatible
if exists('g:already_patched')
	unlet g:already_patched
endif
unlet g:LOCALSHAREPATH
unlet g:PLUGINS_INSTALL_FILE_PATH
unlet g:PLUGINS_SETUP_FILE_PATH
unlet g:PLUGINS_SETUP_PATH

unmap <leader>?

let old_winid = win_getid()
function! Remove_excess_buffers()
	if &filetype ==# "notify"
		bwipeout!
		return
	endif
endfunction
tabdo windo call Remove_excess_buffers()
delfunction Remove_excess_buffers
call win_gotoid(old_winid)
unlet old_winid
function! Remove_excess_mappings()
	silent! nunmap <buffer> <space>
	silent! nunmap <buffer> \
	silent! nunmap <buffer> z
	silent! nunmap <buffer> z=
endfunction
call timer_start(100, {->execute('execute "bufdo! call Remove_excess_mappings()"|delfunction Remove_excess_mappings')})

unlet g:exnvim_mapleader
unlet mapleader

delfunction ExNvimSource
delfunction InvokeCriticalError

hi clear
execute "noremap z01 <cmd>let g:CONFIG_PATH=\"".g:CONFIG_PATH."\"<bar>execute \"source \".g:CONFIG_PATH.\"/vim/exnvim/reload.vim\"<cr>"
unlet g:CONFIG_PATH
