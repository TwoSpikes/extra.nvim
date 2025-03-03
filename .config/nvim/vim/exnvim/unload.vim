if !exists('g:exnvim_fully_loaded')
	finish
endif
if g:exnvim_fully_loaded !=# 3
	finish
endif

execute 'source' stdpath('config').'/vim/exnvim/unload_config.vim'
let g:compatible = "common"

execute 'source' stdpath('config').'/vim/compatible/common/unload/unload.vim'
let g:compatible = "empty"

autocmd! AlphaNvim_CinnamonNvim_JK_Workaround *
augroup! AlphaNvim_CinnamonNvim_JK_Workaround
if has('nvim')
	autocmd! exnvim_term_closed *
	augroup! exnvim_term_closed
endif
delfunction AfterSomeEvent
if PluginExists('ani-cli.nvim')
	delcommand Ani
	delfunction AniCli
	if exists('g:ANI_CLI_TO_EXIT')
		unlet g:ANI_CLI_TO_EXIT
	endif
endif
if has('nvim')
	delfunction ChangeLanguage_system_english
	delfunction ChangeLanguage_system_russian
	delfunction ChangeLanguage_system
	delfunction ChangeLanguage
	unmap <leader><leader>
endif
if PluginExists('coc.nvim')
	autocmd! exnvim_coc_nvim *
	augroup! exnvim_coc_nvim
	autocmd! coc_nvim *
	augroup! coc_nvim
	delfunction CheckBackspace
	delfunction CocAction
	delcommand OR
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
autocmd! exnvim_colorscheme *
augroup! exnvim_colorscheme
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
delcommand GitClone
delfunction GitClone
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
delfunction InitPckr
delcommand InvertPdf
delfunction InvertPdf
if exists('*IsHighlightGroupDefined')
	delfunction IsHighlightGroupDefined
endif
delfunction IsNo
delfunction IsYes
delfunction JKWorkaround
delfunction JKWorkaroundAlpha
delfunction Killbuffer
delfunction LoadExNvimConfig
delfunction LoadVars
delfunction Lua_Require_Goto_Workaround_Wincmd_f
delfunction MakeThingsThatRequireBeDoneAfterPluginsLoaded
if exists('*Mason_better')
	delfunction Mason_better
endif
delfunction MatchDisable
delfunction MatchEnable
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
autocmd! exnvim_mode_changed_numbertoggle *
augroup! exnvim_mode_changed_numbertoggle
autocmd! neo-tree *
augroup! neo-tree
autocmd! netrw *
augroup! netrw
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
if PluginExists('coc.nvim')
	delfunction ShowDocumentation
endif
delcommand ShFunction
delfunction ShFunction
delcommand ShRun
delfunction ShRun
delcommand ShSource
delfunction ShSource
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
if PluginExists('vim-visual-multi')
	nunmap <c-n>
	xunmap <c-n>
	nunmap <Plug>(VM-Find-Under)
	xunmap <Plug>(VM-Find-Subword-Under)
	if exists('*vm#commands#ctrln')
		delfunction vm#commands#ctrln
	endif
	if exists('*vm#themes#statusline')
		delfunction vm#themes#statusline
	endif
	delfunction VMInfos
endif
delfunction WhenceGroup
delfunction X_CommentOut
delfunction X_CommentOutDefault
delfunction X_Comment_Move_Left
delfunction X_Comment_Move_Right
delfunction X_UncommentOut
delfunction X_UncommentOutDefault

if PluginInstalled('alpha')
	execute "lua package.loaded['alpha'] = nil"
	delcommand Alpha
	delcommand AlphaRedraw
	delcommand AlphaRemap
endif
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
	autocmd! ___cmp___ *
	augroup! ___cmp___
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
	autocmd! dap.exit *
	augroup! dap.exit
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
delcommand EnableHLChunk
if PluginExists('emmet-vim')
	delcommand Emmet
	delcommand EmmetInstall
endif
delcommand ExNvimCheatSheet
delcommand ExNvimCommit
if filereadable(expand(stdpath('config').'/vim/xterm-color-table.vim'))
	delcommand Exct
	delcommand Oxct
	delcommand Sxct
	delcommand Txct
	delcommand Vxct
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
if PluginInstalled('hex')
	delcommand HexAssemble
	delcommand HexDump
	delcommand HexToggle
endif
if PluginInstalled('illuminate')
	autocmd! vim_illuminate_v2_augroup
	delcommand IlluminateDebug
	delcommand IlluminatePause
	delcommand IlluminatePauseBuf
	delcommand IlluminateResume
	delcommand IlluminateResumeBuf
	delcommand IlluminateToggle
	delcommand IlluminateToggleBuf
endif
if PluginInstalled('jdtls')
	delcommand JdtShowLogs
	delcommand JdtWipeDataAndRestart
endif
if PluginExists('limelight.vim')
	delcommand Limelight
endif
if PluginInstalled('lspconfig')
	delcommand LspInfo
	delcommand LspLog
	delcommand LspRestart
	delcommand LspStart
	delcommand LspStop
endif
if PluginInstalled('LspUI')
	delcommand LspUI
endif
if PluginInstalled('luasnip')
	autocmd! luasnip *
	augroup! luasnip
	delcommand LuaSnipListAvailable
	delcommand LuaSnipUnlinkCurrent
endif
if PluginExists('vim-man')
	delcommand Man
	delcommand Sman
	delcommand Mangrep
endif
if PluginInstalled('mason')
	delcommand Mason
endif
delcommand Md
if PluginExists('mdmath.nvim')
	delcommand MdMath
endif
if PluginInstalled('neogen')
	delcommand Neogen
endif
if PluginInstalled('neo-tree')
	delcommand Neotree
endif
if PluginInstalled('noice')
	autocmd! noice.message *
	augroup! noice.message
	delcommand Noice
	delcommand NoiceAll
	delcommand NoiceConfig
	delcommand NoiceDebug
	delcommand NoiceDisable
	delcommand NoiceDismiss
	delcommand NoiceEnable
	delcommand NoiceErrors
	delcommand NoiceFzf
	delcommand NoiceHistory
	delcommand NoiceLast
	delcommand NoiceLog
	delcommand NoicePick
	delcommand NoiceRoutes
	delcommand NoiceSnacks
	delcommand NoiceStats
	delcommand NoiceTelescope
	delcommand NoiceViewstats
	lua require('noice').disable()
	execute "lua package.loaded['noice'] = nil"
endif
if PluginInstalled('notify')
	delcommand Notifications
	delcommand NotificationsClear
	execute "lua package.loaded['notify'] = nil"
	lua vim.notify = vim.oldnotify
	lua vim.oldnotify = nil
endif
if PluginInstalled('null-ls')
	delcommand NullLsInfo
	delcommand NullLsLog
endif
if PluginInstalled('lazy')
	delcommand Lazy
endif
if PluginInstalled('plenary')
	delcommand PlenaryBustedDirectory
	delcommand PlenaryBustedFile
endif
if PluginExists('vim-quickui')
	delcommand QuickUI
endif
delcommand Rm
delcommand SWrap
if PluginInstalled('persisted')
	delcommand SessionDelete
	delcommand SessionLoad
	delcommand SessionLoadLast
	delcommand SessionSave
	delcommand SessionSelect
	delcommand SessionStart
	delcommand SessionStop
	delcommand SessionToggle
endif
delcommand Showtab
if PluginInstalled('spectre')
	delcommand Spectre
endif
if PluginInstalled('nvim-treesitter')
	delcommand TSBufDisable
	delcommand TSBufEnable
	delcommand TSBufToggle
	delcommand TSCaptureUnderCursor
	delcommand TSConfigInfo
	delcommand TSDisable
	delcommand TSEditQuery
	delcommand TSEditQueryUserAfter
	delcommand TSEnable
	delcommand TSHighlightCapturesUnderCursor
	delcommand TSInstall
	delcommand TSInstallFromGrammar
	delcommand TSInstallInfo
	delcommand TSInstallSync
	delcommand TSModuleInfo
	delcommand TSNodeUnderCursor
	delcommand TSPlaygroundToggle
	delcommand TSToggle
	delcommand TSUninstall
	delcommand TSUpdate
	delcommand TSUpdateSync
endif
if PluginExists('tagbar')
	delcommand Tagbar
	delcommand TagbarClose
	delcommand TagbarCurrentTag
	delcommand TagbarDebug
	delcommand TagbarDebugEnd
	delcommand TagbarForceUpdate
	delcommand TagbarGetTypeConfig
	delcommand TagbarJump
	delcommand TagbarJumpNext
	delcommand TagbarJumpPrev
	delcommand TagbarOpen
	delcommand TagbarOpenAutoClose
	delcommand TagbarSetFoldlevel
	delcommand TagbarShowTag
	delcommand TagbarToggle
	delcommand TagbarTogglePause
endif
if PluginInstalled('todo-comments')
	delcommand TodoTelescope
endif
if PluginInstalled('telescope')
	delcommand Telescope
endif
if PluginExists('vim-terminator')
	delcommand TerminatorOpenTerminal
	delcommand TerminatorOutputBufferClose
	delcommand TerminatorOutputBufferToggle
	delcommand TerminatorRunAltCmd
	delcommand TerminatorRunFileInOutputBuffer
	delcommand TerminatorRunFileInTerminal
	delcommand TerminatorRunPartOfFileInOutputBuffer
	delcommand TerminatorRunPartOfFileInTerminal
	delcommand TerminatorSendDelimiterToTerminal
	delcommand TerminatorSendSelectionToTerminal
	delcommand TerminatorSendToTerminal
	delcommand TerminatorStartREPL
	delcommand TerminatorStopRun
endif
if PluginExists('vim-man')
	delcommand Tman
endif
if PluginInstalled('todo-comments')
	delcommand TodoFzfLua
	delcommand TodoLocList
	delcommand TodoQuickFix
	delcommand TodoTrouble
endif
if PluginInstalled('trouble')
	delcommand Trouble
endif
if PluginExists('vim-visual-multi')
	delcommand VMClear
	delcommand VMDebug
	delcommand VMFromSearch
	delcommand VMLive
	delcommand VMRegisters
	delcommand VMSearch
	delcommand VMTheme
endif
if PluginExists('vital.vim')
	delcommand Vitalize
endif
if PluginExists('vim-man')
	delcommand Vman
endif
if PluginExists('vim-vsnip')
	delcommand VsnipOpen
	delcommand VsnipOpenEdit
	delcommand VsnipOpenSplit
	delcommand VsnipOpenVsplit
	delcommand VsnipYank
endif
if PluginInstalled('which-key')
	execute "lua package.loaded['which-key'] = nil"
	autocmd! wk *
	augroup! wk
	delcommand WhichKey
endif
delcommand Write

if PluginInstalled('edgy')
	execute "lua package.loaded['edgy'] = nil"
endif
if PluginInstalled('mini.bracketed')
	autocmd! MiniBracketed *
	augroup! MiniBracketed
endif
if PluginInstalled('nvim-ts-autotag')
	execute "lua package.loaded['nvim-ts-autotag'] = nil"
	autocmd! nvim_ts_xmltag *
	augroup! nvim_ts_xmltag
endif
if PluginInstalled('hlargs')
	execute "lua package.loaded['hlargs'] = nil"
	autocmd! Hlargs *
	augroup! Hlargs
endif
if PluginInstalled('lazy')
	execute "lua package.loaded['lazy'] = nil"
	autocmd! lazy_handler_event *
	augroup! lazy_handler_event
	unlet g:lazy_did_setup
endif
if PluginInstalled('beacon')
	execute "lua package.loaded['beacon'] = nil"
	autocmd! beacon_group *
	augroup! beacon_group
endif
delfunction PluginInstalled
if PluginExists('music-player.vim')
	autocmd! music_player_track_switching *
	augroup! music_player_track_switching
endif
delfunction PluginExists

unlet g:CONFIG_ALREADY_LOADED
unlet g:exnvim_fully_loaded
unlet g:compatible
if exists('g:already_patched')
	unlet g:already_patched
endif

noremap z01 <cmd>execute 'source' stdpath('config').'/vim/exnvim/reload.vim'<cr>
