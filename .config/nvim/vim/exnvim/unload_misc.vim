if PluginExists('ani-cli.nvim')
	delcommand Ani
	delfunction AniCli
	if exists('g:ANI_CLI_TO_EXIT')
		unlet g:ANI_CLI_TO_EXIT
	endif
endif
if PluginExists('coc.nvim') && !g:use_nvim_cmp
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
if exists('*Mason_better')
	delfunction Mason_better
endif
if PluginExists('coc.nvim') && !g:use_nvim_cmp
	delfunction ShowDocumentation
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
	execute "lua package.loaded['cmp'] = nil"
endif
if PluginExists('coc.nvim') && !g:use_nvim_cmp
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
if PluginExists('hlchunk.nvim')
	delcommand EnableHLChunk
endif
if PluginExists('emmet-vim')
	delcommand Emmet
	delcommand EmmetInstall
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
if PluginExists('coc.nvim') && !g:use_nvim_cmp
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
endif
if PluginInstalled('luasnip')
	autocmd! luasnip *
	augroup! luasnip
	delcommand LuaSnipListAvailable
	delcommand LuaSnipUnlinkCurrent
	sunmap <tab>
endif
if PluginExists('vim-man')
	delcommand Man
	delcommand Sman
	delcommand Mangrep
endif
if PluginInstalled('mason')
	delcommand Mason
endif
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
	lua require('noice').deactivate()
	execute "lua package.loaded['noice'] = nil"
	execute "lua package.loaded['noice.util'] = nil"
	execute "lua package.loaded['noice.config'] = nil"
	execute "lua package.loaded['noice.lsp'] = nil"
	execute "lua package.loaded['noice.message'] = nil"
	execute "lua package.loaded['noice.ui'] = nil"
	execute "lua package.loaded['noice.view'] = nil"
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
if isdirectory(g:LOCALSHAREPATH.'/site/autoload/plug.vim')
	delcommand Plug
	delcommand PlugClean
	delcommand PlugDiff
	delcommand PlugInstall
	delcommand PlugSnapshot
	delcommand PlugStatus
	delcommand PlugUpdate
	delcommand PlugUpgrade
endif
if PluginInstalled('plenary')
	delcommand PlenaryBustedDirectory
	delcommand PlenaryBustedFile
endif
if PluginExists('vim-quickui')
	delcommand QuickUI
	unlet g:quickui_version
	unlet g:quickui_border_style
	unlet g:quickui_color_scheme
	unlet g:quickui_icons
	if exists('g:quickui_show_tip')
		unlet g:quickui_show_tip
	endif
	if exists('g:quickui_highlight_tmp')
		unlet g:quickui_highlight_tmp
	endif
endif
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
	autocmd! vsnip *
	augroup! vsnip
	delcommand VsnipOpen
	delcommand VsnipOpenEdit
	delcommand VsnipOpenSplit
	delcommand VsnipOpenVsplit
	delcommand VsnipYank
endif
if PluginInstalled('which-key')
	execute "lua package.loaded['which-key'] = nil"
	execute "lua package.loaded['which-key.state'] = nil"
	autocmd! wk *
	augroup! wk
	delcommand WhichKey
	ounmap z
endif
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
if PluginInstalled('beacon')
	execute "lua package.loaded['beacon'] = nil"
	autocmd! beacon_group *
	augroup! beacon_group
endif
if PluginExists('music-player.vim')
	autocmd! music_player_track_switching *
	augroup! music_player_track_switching
endif
