" Settings required for Vundle (and are good to have, anyway)
set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
if has("win32")
    set rtp+=~/.vim/bundle/Vundle.vim
else
    set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'fisadev/vim-isort'
Plugin 'majutsushi/tagbar'
Plugin 'pignacio/vim-yapf-format'
Plugin 'python-mode/python-mode'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/Gundo'
" Plugin 'vim-syntastic/syntastic'

call vundle#end()
filetype indent plugin on

behave xterm

" Enable syntax highlighting
syntax on

colorscheme wombat

" Execute file being edited with <Shift> + e:
if has("win32")
    map <buffer> <S-e> :w<CR>:!python % <CR>
else
    map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
endif

" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline

set autoindent
set backspace=indent,eol,start
set clipboard=unnamed
set cmdheight=2
set confirm
set cul
set hi=1000
set hidden
" Set the command window height to 2 lines, to avoid many cases of having to
" 'press <Enter> to continue'
" Always display the status line, even if only one window is displayed
set laststatus=2
set mouse=a
set notimeout ttimeout ttimeoutlen=200
set number
set path=.,,**
set ruler
set showcmd
set t_vb=
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set wildmenu
set visualbell

" Folding settings ...
set foldlevel=1
set foldmethod=indent
set foldnestmax=2
set nofoldenable

" 'pastetoggle'| Key code that causes 'paste' to toggle
set pt=<F4>

" Tab-related stuff.
set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4

" Search/case-related stuff.
set hlsearch
set ignorecase
set smartcase
set incsearch

" 'statusline' | Custom format for the status line
set stl=%<[%n]\ %F\ \ Filetype=\%Y\ \ %r\ %1*%m%*%w%=%(Line:\ %l%)%4(%)Column:\ %5(%c%V/%{strlen(getline(line('.')))}%)\ %4(%)%p%%

autocmd FileType text setlocal textwidth=79

" This will highlight column 80 for a few filetypes ...
set colorcolumn=80
autocmd FileType python highlight ColorColumn ctermbg=DarkGrey guibg=DarkRed
autocmd FileType c highlight ColorColumn ctermbg=DarkGrey guibg=DarkRed

" This will make any characters beyond position 80 hightlighted.
autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=DarkRed
autocmd FileType python match Excess /\%81v.*/
autocmd FileType c highlight Excess ctermbg=DarkGrey guibg=DarkRed
autocmd FileType c match Excess /\%81v.*/
"autocmd FileType python set nowrap

" -----------------------------------------------------------------------------
" MAPPINGS
" -----------------------------------------------------------------------------

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

nnoremap <space> za
vnoremap <space> zf

" set ofu=syntaxcomplete#Complete
" autocmd FileType python runtime! autoload/pythoncomplete.vim
" autocmd FileType python set omnifunc=pythoncomplete#Complete

" Let's be friendly :)
autocmd VimEnter * echo "Hey, Hoaf! What's shakin'?"
autocmd VimLeave * echo "Have fun storming the castle!"

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" -----------------------------------------------------------------------------
" PLUGIN-RELATED GOODIES
" -----------------------------------------------------------------------------

" tagbar stuff.
nmap <F8> :TagbarToggle<CR>

" NERDTree stuff.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <silent> <C-n> :NERDTreeToggle<CR>

" vim-airline stuff.
let g:airline_powerline_fonts=1

if has("gui_running")
    if has("gui_win32")
        scriptencoding utf-8
        if has("multi_byte")
            if &termencoding == ""
                let &termencoding = &encoding
            endif
            set encoding=utf-8
            setglobal fileencoding=utf-8
            "setglobal bomb
            set fileencodings=ucs-bom,utf-8,latin1
        endif
        set guifont=Ubuntu_Mono_derivative_Powerlin:h14:cANSI

    else
        set guifont=Source\ Code\ Pro\ for\ Powerline\ 14
    endif
endif

" Python formatting stuff.
fun PythonPrettifyCode()
    if &ft != "python"
        return
    endif
    Isort
    YapfFullFormat
endfun

autocmd BufWritePre * call PythonPrettifyCode()
