set noswapfile
set number "行番号を表示する
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け

"==== 検索設定 ====#
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

"==== タブ・インデント設定 ====
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=4 "画面上でタブ文字が占める幅
set shiftwidth=4 "自動インデントでずれる幅
set softtabstop=4 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する

"==== ファイル保存 ====
set fileencoding=utf-8


"==== Teraterm 挿入モードから抜けた時に IMEをオフにし、再度挿入モードに入った時に IME の状態を元に戻すようになります。
 let &t_SI .= "\e[<r"
 let &t_EI .= "\e[<s\e[<0t"
 let &t_te .= "\e[<0t\e[<s"
 set timeoutlen=100

"==== Tab番号表示設定
"==== t1,t2, t9 でタブ移動が可能
"==== tc で新しいタブ, txでタブを閉じる
"Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
let bufnrs = tabpagebuflist(i)
let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
let no = i  " display 0-origin tabpagenr.
let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
let title = fnamemodify(bufname(bufnr), ':t')
let title = '[' . title . ']'
let s .= '%'.i.'T'
let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
let s .= no . ':' . title
let s .= mod
let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap[Tag]   <Nop>

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


"==== タブ、空白、改行の可視化 ====
"set list
"set listchars=tab:>.,trail:_,eol:?,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction
   
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif



"==== ColorScheme 設定 ====
 set t_Co=256
 "カラースキーマを設定 molokai
 colorscheme molokai
 syntax on
 let g:molokai_original = 1
 let g:rehash256 = 1

"==== UniteVim設定 ====

set nocompatible   " be iMproved
filetype off

"==== VimFiler設定 ====
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
"    call neobundle#begin(expand('~/.vim/bundle/'))
"    NeoBundleFetch 'Shougo/neobundle.vim'
"    call neobundle#end()

    call neobundle#begin(expand('~/.vim/bundle'))
    NeoBundleFetch 'Shougo/neobundle.vim'
    NeoBundle '...'
    NeoBundle '...'

    " originalrepos on github
    NeoBundle 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc'
    NeoBundle 'VimClojure'
    NeoBundle 'Shougo/vimshell'
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/neocomplcache'
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'Shougo/neosnippet-snippets'
    NeoBundle 'jpalardy/vim-slime'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'Shougo/vimfiler'
    NeoBundle 'https://bitbucket.org/kovisoft/slimv'

    " go
    NeoBundle 'fatih/vim-go'

    call neobundle#end()

endif

" vim-go設定
let g:go_gocode_propose_source = 0
let g:go_bin_path = $GOPATH.'/bin'
" GoLint、GoVet、GoErrCheckをまとめてCheck
let g:go_metalinter_autosave = 1 
" 保存時自動Import
let g:go_fmt_command = "goimports"


filetype plugin indent on " required!
filetype indent on
syntax on

" vim起動時に vimfile split を自動で実行するように
autocmd VimEnter * VimFiler -split -simple -winwidth=50 -no-quit

" markdownのハイライトを有効にする
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown
