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
nunmap k
ounmap k
vunmap k
delfunction ProcessGBut
delfunction STCRel
