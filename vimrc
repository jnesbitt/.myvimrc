execute pathogen#infect()

" Enable filetype plugins
filetype plugin on

" Causes problems with paste
"filetype indent on

colorscheme desert

" Set 3 lines to the cursor - when moving vertically using j/k
set so=3

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

fixdel
set nu

" Configure backspace so it acts as it should act
set backspace=indent,eol,start

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Highlight search results
set hlsearch

" To move the cursor to the matched string, while typing the search pattern
set incsearch 

" More normal regex
set magic

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 3 spaces
set shiftwidth=3
set tabstop=3

set ai "Auto indent
set si "Smart indent
" set wrap "Wrap lines
set nowrap

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

"Always show current position
set ruler
"set cmdheight=2
"
" Enable syntax highlighting
syntax enable 

" work properly with clipboard
set clipboard=unnamed

" status line
" set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"
" set laststatus=2
" set noruler

" XML Folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax       

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
