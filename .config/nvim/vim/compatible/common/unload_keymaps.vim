nunmap <leader>G

nunmap dd
nunmap -
nunmap +

unmap J
unmap gJ

unmap <leader><c-f>
unmap <f3>

unmap <c-t>

nunmap <leader>xg

unmap <c-a>
unmap <c-e>
iunmap <c-a>
iunmap <c-e>

cunmap <c-a>
cunmap <c-g>
if g:insert_exit_on_jk
	cunmap jk
endif
cunmap <c-u>
cunmap <c-b>

nunmap <c-j>
vunmap <c-j>
iunmap <c-j>

nunmap <bs>
unmap <leader><bs>

nunmap <c-c>%
nunmap <c-c>"
nunmap <c-c>w
for i in range(1, 9)
	execute "nunmap <c-c>".i
endfor

nunmap *
nunmap <c-*>
nunmap #
nunmap <c-#>

unmap <leader>l
unmap <leader>h
iunmap <c-l>
iunmap <c-h>
unmap <c-Y>
unmap <ScrollWheelDown>
unmap <ScrollWheelUp>

if executable('rg')
	unmap <leader>st
	nunmap <leader>sw
	vunmap <leader>sw
	unmap <leader>sp
endif

unmap <leader>ve
unmap <leader>se
unmap <leader>vi
unmap <leader>si
unmap <leader>vs
unmap <leader>ss
unmap <leader>vl
unmap <leader>sl
unmap <leader>vj
unmap <leader>sj

if filereadable(expand("~/.dotfiles-script.sh"))
	unmap <leader>vb
endif

if v:false
\|| g:open_cmd_on_up ==# "insert"
\|| g:open_cmd_on_up ==# "run"
	nunmap <up>
endif
xunmap <up>

unmap <leader>:
unmap <leader>=
unmap <leader>-
unmap <leader>1
nunmap <leader>up

nunmap ci_
nunmap <esc>
iunmap <c-c>

unmap <leader>.
unmap <leader>%

unmap <leader>vc
unmap <leader>vC

unmap <leader>uc
unmap <leader>ut

nunmap <leader>c
xunmap <leader>c
nunmap <leader>C
xunmap <leader>C

nunmap <leader>A
xunmap <leader>A

unmap q
unmap Q
unmap <c-w><c-g>

unmap <c-x><c-c>
unmap <c-x><c-q>
unmap <c-x>s
unmap <c-x>S
unmap <c-x><c-s>
unmap <c-x>k
unmap <c-x>0
unmap <c-x>1
unmap <c-x>2
unmap <c-x>3
unmap <c-x>o
unmap <c-x>O
unmap <c-x>t0
unmap <c-x>t1
unmap <c-x>t2
unmap <c-x>to
unmap <c-x>tO
unmap <c-x>5
unmap <m-x>
unmap <c-x>h
unmap <c-x><c-h>
unmap <c-x><c-g>

unmap mz
unmap my

unmap <leader>q
unmap <leader>Q

if g:insert_exit_on_jk
	iunmap jk
	iunmap JK
endif

iunmap ju
iunmap ji

iunmap (
iunmap [
iunmap {
iunmap )
iunmap ]
iunmap }
iunmap '
iunmap "
iunmap `
iunmap <bs>

unmap <leader>so

unmap <f10>
unmap <f9>

nunmap <c-x><c-b>

if executable('lazygit')
	unmap <leader>z
endif
if v:false
\|| executable('far')
\|| executable('far2l')
\|| executable('mc')
	unmap <leader>m
endif

unmap <leader>x.
unmap <leader>x%

if has('nvim') && PluginInstalled('neo-tree')
	nunmap <c-h>
endif

nunmap <leader>n

nunmap <c-w>o
nunmap <c-w><c-o>
nunmap <c-w>q
nunmap <c-w><c-q>
nunmap <c-w>f
nunmap <c-w>F
nunmap <c-w>gf
nunmap <c-w>gF
nunmap <c-w>gt
nunmap <c-w>gT
nunmap <c-w>j
nunmap <c-w><down>
nunmap <c-w>k
nunmap <c-w><up>
nunmap <c-w>h
nunmap <c-w><left>
nunmap <c-w>l
nunmap <c-w><right>
nunmap <c-w>t
nunmap <c-w>b
nunmap <c-w>J
nunmap <c-w>K
nunmap <c-w>H
nunmap <c-w>L
nunmap <c-w>+
nunmap <c-w>-
nunmap <c-w><
nunmap <c-w>>
nunmap <c-w>=
nunmap <c-w>P
nunmap <c-w><c-p>
nunmap <c-w>R
nunmap <c-w><c-r>
nunmap <c-w>s
nunmap <c-w>S
nunmap <c-w>T
nunmap <c-w>w
nunmap <c-w>x
nunmap <c-w>W
nunmap <c-w>]
nunmap <c-w>^
nunmap <c-w><c-^>
nunmap <c-w>_
nunmap <c-w><c-_>
nunmap <c-w>c
nunmap <c-w>d
nunmap <c-w>g<c-]>
nunmap <c-w>g]
nunmap <c-w>g}
nunmap <c-w>g<tab>
nunmap <c-w>i
nunmap <c-w>p
nunmap <c-w>r
nunmap <c-w>z
nunmap <c-w>\|

nunmap <c-p>
vunmap <c-p>

if has('nvim') && PluginExists('vim-fugitive')
	nunmap <leader>gc
	nunmap <leader>ga
	nunmap <leader>gA
	nunmap <leader>gp
	nunmap <leader>gP
	nunmap <leader>gr
	nunmap <leader>gh
	nunmap <leader>gm
	nunmap <leader>gs
	nunmap <leader>gi
	nunmap <leader>gC
	nunmap <leader>g1
	nunmap <leader>gR
	nunmap <leader>g2
endif

if PluginExists('ani-cli.nvim')
	unmap <leader>xa
	unmap <leader>xA
endif

unmap <leader>xi

unmap <leader>g*

unmap <leader>xP

if PluginInstalled('activate')
	unmap <leader>xp
endif

unmap z00
