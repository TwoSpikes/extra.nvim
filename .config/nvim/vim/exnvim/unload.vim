if !exists('g:exnvim_fully_loaded')
	finish
endif
if g:exnvim_fully_loaded !=# 3
	finish
endif

execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload_config.vim'

autocmd! AlphaNvim_CinnamonNvim_JK_Workaround *
augroup! AlphaNvim_CinnamonNvim_JK_Workaround
autocmd! exnvim_term_closed *
augroup! exnvim_term_closed
delfunction AfterSomeEvent
delfunction AfterUpdatingPlugins
delfunction ApplyColorscheme
delfunction BeforeUpdatingPlugins
if has('nvim')
	delfunction ChangeLanguage
	unmap <leader><leader>
	delfunction ChangeNames
endif
if PluginExists('coc.nvim')
	autocmd! exnvim_coc_nvim *
	augroup! exnvim_coc_nvim
	delfunction CheckBackspace
	delfunction CocAction
	delfunction CocActionAsync
	delfunction CocHasProvider
	delfunction CocLocations
	delfunction CocLocationsAsync
	delfunction CocNotify
	delfunction CocPopupCallback
	delfunction CocRegistNotification
	delfunction CocRegisterNotification
	delfunction CocRequest
	delfunction CocRequestAsync
	delfunction CocTagFunc
endif
delfunction ColorSchemeManagePre
delfunction ColorTable
delfunction Contains
delfunction CopyHighlightGroup
delfunction DefineAugroupNumbertoggle
delfunction DefineAugroupVisual
delfunction DefineAugroups
delfunction Defone
delfunction DisablePagerMode
delfunction DoCommentOutDefault
delfunction DoPackerUpdate
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
	unmap <c-x><c-f>
	unmap <c-c>C
	delcommand Findfilebuffer
	delfunction Findfilebuffer
endif
autocmd! exnvim_fix_sha_da *
augroup! exnvim_fix_sha_da
delfunction FixShaDa
if PluginExists('vim-fugitive')
	delfunction FugitiveActualDir
	delfunction FugitiveCommonDir
	delfunction FugitiveConfig
	delfunction FugitiveConfigGet
	delfunction FugitiveConfigGetAll
	delfunction FugitiveConfigGetRegexp
	delfunction FugitiveDetect
	delfunction FugitiveDidChange
	delfunction FugitiveExecute
	delfunction FugitiveExtractGitDir
	delfunction FugitiveFind
	delfunction FugitiveGitDir
	delfunction FugitiveGitPath
	delfunction FugitiveGitVersion
	delfunction FugitiveHead
	delfunction FugitiveIsGitDir
	delfunction FugitiveParse
	delfunction FugitivePath
	delfunction FugitiveReal
	delfunction FugitiveRemote
	delfunction FugitiveRemoteUrl
	delfunction FugitiveResult
	delfunction FugitiveShellCommand
	delfunction FugitiveStatusline
	delfunction FugitiveVimPath
	delfunction FugitiveWorkTree
endif
delfunction FuzzyFind
delfunction GenerateExNvimConfig
delfunction GenerateTemporaryAutocmd
set stl=
delfunction GetGitBranch
delfunction GetRandomName
delfunction GetVisualSelection
autocmd! exnvim_handle_buftype *
augroup! exnvim_handle_buftype
delfunction HandleBuftype
delfunction HandleBuftypeAll
delfunction HandleExNvimConfig
autocmd! ExNvimOptionsInComment *
augroup! ExNvimOptionsInComment
delfunction HandleExNvimOptionsInComment
delfunction HandleKeystroke
delfunction IfOneWinDo
delfunction IfOneWinDoElse
delfunction InitPckr
delfunction IsHighlightGroupDefined
delfunction IsNo
delfunction IsOneWin
delfunction IsYes
delfunction JKWorkaround
delfunction JKWorkaroundAlpha
delfunction Killbuffer
delfunction LoadExNvimConfig
delfunction LoadVars
delfunction Lua_Require_Goto_Workaround_Wincmd_f
delfunction MakeThingsThatRequireBeDoneAfterPluginsLoaded
delfunction Mason_better
delfunction MatchDisable
delfunction MatchEnable
set tabline=
delfunction MyTabLabel
delfunction MyTabLine
nunmap <leader>c
delfunction N_CommentOut
delfunction N_CommentOutDefault
delfunction N_Comment_Move_Left
delfunction N_Comment_Move_Right
delfunction N_UncommentOut
delfunction N_UncommentOutDefault
autocmd! numbertoggle *
augroup! numbertoggle
autocmd! exnvim_mode_changed_numbertoggle *
augroup! exnvim_mode_changed_numbertoggle
delfunction Numbertoggle
delfunction NumbertoggleAll
delfunction Numbertoggle_no
delfunction Numbertoggle_stcabs
delfunction Numbertoggle_stcrel
delfunction OnFirstTime
autocmd! exnvim_vim_leave *
augroup! exnvim_vim_leave
delfunction OnQuit
delfunction OnQuitDisable
delfunction OnStart
delfunction OpenOnStart
delfunction OpenRanger
delfunction OpenRangerCheck
unmap <leader>t
delfunction OpenTerm
unmap <leader>xx
delfunction OpenTermProgram
delfunction OpenWithXdg
delfunction Pad
delfunction Pad_middle
delfunction PleaseDoNotCloseIfNotOneWin
delfunction PleaseDoNotCloseIfOneWin
delfunction PleaseDoNotCloseWrapper
delfunction PluginDelete
unmap <leader>vs
unmap <leader>ve
unmap <leader>vi
unmap <leader>vl
unmap <leader>vj
unmap <leader>vc
unmap <leader>vb
delfunction SelectPosition
delfunction SaveAsBase
delfunction SaveAs
delfunction SaveAsAndRename
delfunction PrePad
delfunction PreparePersistedNvim
delfunction PrepareWhichKey
delfunction PreserveAndDo
delfunction RebindMenus
delfunction RedefineProcessGBut
delfunction RehandleExNvimConfig
delfunction Remove
delfunction Repr_Shell
delfunction Repr_Vim_Grep
delfunction RestoreCursorFix
delfunction ReturnHighlightTerm
delfunction RunAlphaIfNotAlphaRunning
delfunction STCAbs
delfunction STCNo
delfunction STCNoAll
nunmap k
ounmap k
vunmap k
nunmap <up>
ounmap <up>
vunmap <up>
delfunction ProcessGBut
delfunction STCRel
call timer_stop(g:exnvim_stc_timer)
unlet g:exnvim_stc_timer
delfunction STCUpd
delfunction SaveVars
delfunction Save_WW_and_Do
unmap <c-x>h
delfunction SelectAll
delfunction SetConfigPath
delfunction SetDefaultValuesForStartupOptionsAndExNvimConfigOptions
delfunction SetExNvimConfigPath
autocmd! exnvim_gitbranch *
augroup! exnvim_gitbranch
delfunction SetGitBranch
delfunction SetLocalSharePath
delfunction SetMouse
delfunction SetTermuxConfigPath
if PluginExists('coc.nvim')
	delfunction ShowDocumentation
endif
delfunction Showtab
delfunction StartsWith
delfunction SynGroup
delfunction SynStack
delfunction TermRunning
delfunction TermuxLoadCursorStyle
delfunction TermuxSaveCursorStyle
unmap <leader><c-f>
delfunction ToggleFullscreen
unmap <leader>xp
delfunction TogglePagerMode
delfunction Trim
delfunction Update_CursorLine
delfunction Update_CursorLine_Style
delfunction Update_Cursor_Style
delfunction Update_Cursor_Style_wrapper
nunmap <c-n>
xunmap <c-n>
nunmap <Plug>(VM-Find-Under)
xunmap <Plug>(VM-Find-Subword-Under)
delfunction vm#commands#ctrln
delfunction vm#themes#statusline
delfunction VMInfos
delfunction WhenceGroup
xunmap <leader>c
delfunction X_CommentOut
delfunction X_CommentOutDefault
delfunction X_Comment_Move_Left
delfunction X_Comment_Move_Right
delfunction X_UncommentOut
delfunction X_UncommentOutDefault

delcommand Alpha
delcommand AlphaRedraw
delcommand AlphaRemap
if PluginInstalled('bqf')
	delcommand BqfAutoToggle
endif
if PluginExists('rust.vim')
	delcommand Cargo
	delcommand Cbench
	delcommand Cbuild
	delcommand Ccheck
	delcommand Cclean
	delcommand Cdoc
	delcommand Cinit
	delcommand Cinstall
	delcommand Cnew
	delcommand Cpublish
	delcommand Crun
	delcommand Cruntarget
	delcommand Csearch
	delcommand Ctest
	delcommand Cupdate
endif
if PluginExists('vim-closetag')
	delcommand CloseTagDisableBuffer
	delcommand CloseTagEnableBuffer
	delcommand CloseTagToggleBuffer
endif
if PluginInstalled('cmp')
	delcommand CmpStatus
endif
if PluginExists('coc.nvim')
	delcommand CocCommand
	delcommand CocConfig
	delcommand CocDiagnostics
	delcommand CocDisable
	delcommand CocEnable
	delcommand CocFirst
	delcommand CocInfo
	delcommand CocInstall
	delcommand CocLast
	delcommand CocList
	delcommand CocListCancel
	delcommand CocListResume
	delcommand CocLocalConfig
	delcommand CocNext
	delcommand CocOpenLog
	delcommand CocOutline
	delcommand CocPrev
	delcommand CocPrintErrors
	delcommand CocRestart
	delcommand CocSearch
	delcommand CocStart
	delcommand CocUninstall
	delcommand CocUpdate
	delcommand CocUpdateSync
	delcommand CocWatch
endif
if PluginInstalled('colorizer')
	delcommand ColorizerAttachToBuffer
	delcommand ColorizerDetachFromBuffer
	delcommand ColorizerReloadAllBuffers
	delcommand ColorizerToggle
endif
if PluginInstalled('conform')
	delcommand ConformInfo
endif
if PluginInstalled('convert')
	delcommand ConvertAll
	delcommand ConvertFindCurrent
	delcommand ConvertFindNext
endif
if PluginInstalled('dap')
	delcommand DapClearBreakpoints
	delcommand DapContinue
	delcommand DapDisconnect
	delcommand DapEval
	delcommand DapNew
	delcommand DapRestartFrame
	delcommand DapSetLogLevel
	delcommand DapShowLog
	delcommand DapStepInto
	delcommand DapStepOut
	delcommand DapStepOver
	delcommand DapTerminate
	delcommand DapToggleBreakpoint
	delcommand DapToggleRepl
endif
if PluginInstalled('diffview')
	delcommand DiffviewClose
	delcommand DiffviewFileHistory
	delcommand DiffviewFocusFiles
	delcommand DiffviewLog
	delcommand DiffviewOpen
	delcommand DiffviewRefresh
	delcommand DiffviewToggleFiles
endif
delcommand DotfilesCommit
if PluginExists('emmet-vim')
	delcommand Emmet
	delcommand EmmetInstall
endif
delcommand ExNvimCheatSheet
delcommand ExNvimCommit
if filereadable(expand(g:CONFIG_PATH.'/vim/xterm-color-table.vim'))
	delcommand Exct
endif
if PluginExists('vim-floaterm')
	delcommand FloatermFirst
	delcommand FloatermHide
	delcommand FloatermKill
	delcommand FloatermLast
	delcommand FloatermNew
	delcommand FloatermNext
	delcommand FloatermPrev
	delcommand FloatermSend
	delcommand FloatermShow
	delcommand FloatermToggle
	delcommand FloatermUpdate
endif
if PluginExists('coc.nvim')
	delcommand Fold
	delcommand Format
endif
if PluginExists('vim-fugitive')
	delcommand GBrowse
	delcommand GDelete
	delcommand GMove
	delcommand GRemove
	delcommand GRename
	delcommand GUnlink
	delcommand Gbrowse
	delcommand GcLog
	delcommand Gcd
	delcommand Gclog
	delcommand Gdelete
	delcommand Gdiffsplit
	delcommand Gdrop
	delcommand Ge
	delcommand Gedit
	delcommand Ggrep
	delcommand Ghdiffsplit
	delcommand Git
endif
delcommand GenerateExNvimConfig
if PluginInstalled('gitsigns')
	delcommand Gitsigns
endif
delfunction PluginInstalled
if PluginExists('vim-fugitive')
	delcommand GlLog
	delcommand Glcd
	delcommand Glgrep
	delcommand Gllog
	delcommand Gmove
endif
if PluginExists('goyo.vim')
	delcommand Goyo
endif
if PluginExists('vim-fugitive')
	delcommand Gpedit
	delcommand Gr
	delcommand Gread
	delcommand Gremove
	delcommand Grename
	delcommand Gsplit
	delcommand Gtabedit
	delcommand Gvdiffsplit
	delcommand Gvsplit
	delcommand Gw
	delcommand Gwq
	delcommand Gwrite
endif
delfunction PluginExists
