set nocompatible

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand("$HOME/.vim/bundle"))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'vim-voom/VOoM'
NeoBundle 'vim-scripts/VimClojure'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'kovisoft/slimv'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'godlygeek/tabular'
NeoBundle 'ytsunetsune/unite-outline-euslisp'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'guns/vim-clojure-static'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'Twinside/vim-haskellFold'
NeoBundle 'ivanov/vim-ipython'
NeoBundle 'groenewege/vim-less'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'vim-pandoc/vim-pandoc'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'jmcantrell/vim-virtualenv'
NeoBundle 'vim-scripts/pydoc.vim'
NeoBundle 'msanders/snipmate.vim'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='xelatex'
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'



" Configuration file for vim
set modelines=1      " CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set backspace=2      " more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup


"Enable support for Color xterm
:if has("terminfo")
:  set t_Co=8
:  set t_Sf=[3%p1%dm
:  set t_Sb=[4%p1%dm
:else
:  set  t_Co=8
:  set t_Sf=[3%dm
:  set t_Sb=[4%dm
:endif




"Turn on line-numbering and auto-indent
:set nu
":set cindent shiftwidth=2
":set cindent cino=>2

"Diable the anti-python smart indent of #
:set ignorecase
:set smartcase
:set autoindent


"SmartIndent for Python
:autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
:autocmd BufRead *.mako set ft=mako
:autocmd BufRead *.tac set ft=python
:autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e

:autocmd BufRead *.md set dictionary+=/usr/share/dict/words

:inoremap # X#

set incsearch
set scrolloff=3
set wildmode=longest,list
set autoread

"Render tabs as 2 columns wide
set tabstop=3 expandtab
set shiftwidth=3
":else
":  set tabstop=3 softtabstop=2 expandtab
":  set shiftwidth=2
":endif

"Code shifting with >> operator will shift code by 2 cols
"    is there a way to shift code by a tab?

"Turn Syntax Highlighting on by default, and assume the xterm background is black
syntax enable
let g:solarized_termtrans=1
set background=dark
set omnifunc=syntaxcomplete#Complete
colorscheme solarized

let python_highlight_all = 1
let python_space_errors=1
let python_no_tab_space_error=1
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
inoremap <F2> :set nonumber! foldcolumn=0<CR>

inoremap <F3> :!spot_control pr<CR>
noremap <F3> :!spot_control pr<CR>
inoremap <F4> :!spot_control p<CR><CR>
noremap <F4> :!spot_control p<CR><CR>
inoremap <F5> :!spot_control n<CR>
noremap <F5> :!spot_control n<CR>

autocmd FileType python set complete+=k~/.vim/syntax/python.vim "isk+=.,(
autocmd FileType python set noexpandtab
autocmd FileType python map K \pW


autocmd FileType pandoc set linebreak tw=110 noexpandtab nosmartindent autoindent
autocmd FileType pantondoc set linebreak tw=110 noexpandtab nosmartindent autoindent
autocmd FileType markdown set linebreak tw=110 noexpandtab nosmartindent autoindent
let g:snips_author="Edward Langley"
let g:pandoc_no_empty_implicits=1
let g:pandoc_use_hard_wraps = 1
"let g:pandoc_auto_format = 1

map W wb"_dwP
map CS :sil! :%s/\s\+$//g<CR>``:%s/^\(\t\+\)\( \+\(\t*\)\)\+/\1\3/gc<CR>``
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

map ZZ :w<CR>
map ZX :wq<cr>

map <BS> dh

" when we reload, tell vim to restore the cursor to the saved position
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

filetype plugin on

:set pastetoggle=<F12>

python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

let counter = 0
inoremap <expr> <C-L> ListItem()
inoremap <expr> <C-R> ListReset()

func ListItem()
 let g:counter += 1
 return g:counter
endfunc

func ListReset()
 let g:counter = 0
 return ''
endfunc

:set diffopt=vertical,filler,iwhite,foldcolumn:0

map <F8> o:,!pbpaste
map <F9> o:,!pbpaste
imap <F8> o:,!pbpaste
imap <F9> o:,!pbpaste

let $PAGER=''
let maplocalleader=','

"command! -range FmtTable python FmtTable(<f-line1>,<f-line2>)

"python << EOS
"def FmtTable(line1,line2):
"    import vim, string
"    inputSeparator='|'
"    outputSeparator="|"
"    cb=vim.current.buffer.range(int(line1)-1,int(line2))
"    colLen=[]
"    # first we collect col lengths and calculate the longest
"    for line in cb[1:]:
"        spLine=line.split(inputSeparator)
"        for i in range(len(spLine)):
"            try:
"                if len(spLine[i]) > colLen[i]:
"                    colLen[i] = len(spLine[i])
"            except IndexError:
"                colLen.append(len(spLine[i]))
"    tmpBuf=[]
"    # Then we fill the cols with spaces
"    for line in cb[1:]:
"        spLine=line.split(inputSeparator)
"        newLine=outputSeparator.join([spElt.ljust(colLen[i]) for i, spElt in enumerate(spLine)]) + outputSeparator
"        tmpBuf.append(newLine)
"    cb[1:]=tmpBuf[:]
"EOS

let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"
let g:ghc="/usr/bin/ghc"
au BufEnter *.hs compiler ghc

:inoremap <Space> <Space><C-g>u
:inoremap <Tab> <Tab><C-g>u
:inoremap <Return> <Return><C-g>u

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1
let vimclojure#WantNailgun = 1


highlight PmenuSel ctermfg=LightGray  ctermbg=DarkRed
nmap <Leader>ci <Plug>VCSCommit

set undodir=~/.vim/undodir
set undofile
set undolevels=10000
set undoreload=100000
set foldlevel=9
set hidden

map <leader>f :Unite file<CR>i
map <leader>q :Unite buffer<CR>i

map <F7> :Unite outlinei
imap <F7> :Unite outlinei
map <C-g> :Unite outlinei
imap <C-g> :Unite outlinei


if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;blue\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;yellow\x7"
  silent !echo -ne "\033]12;yellow\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif

" Pantondoc

let g:pantondoc_handled_filetypes = ["markdown", "rst", "textile"]
let g:pantondoc_enabled_modules =  ["formatting", "folding",
         \"bibliographies", "completion", "externals", "metadata",
         \"menu", "executors", "motions"]
let g:pantondoc_formatting_settings = "h"
let g:lisp_rainbow=1 
let g:slimv_disable_clojure=1

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

set laststatus=2

" airline
"
let g:airline_theme="murmur"

" split settings
"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

let g:syntastic_python_checkers = ['python']

if filereadable(".vim.custom")
    so .vim.custom
endif

