let old_cmdheight=&cmdheight
let old_tabpagenr=tabpagenr()
let old_winnr=winnr()
exec "source ".g:CONFIG_PATH."/init.vim"
exec old_tabpagenr."tabnext"
exec old_winnr."wincmd w"
let &cmdheight=old_cmdheight
unlet old_tabpagenr
unlet old_winnr
unlet old_cmdheight
call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)
execute "Showtab"
