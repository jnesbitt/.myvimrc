execute pathogen#infect()

" Enable filetype plugins
filetype plugin on
filetype on

" Causes problems with paste
"filetype indent on

" colorscheme blink
" colorscheme elflord
  colorscheme gurunew
" set guifont=Menlo\ Regular:h18
" set colorcolumn=90

  set background=dark 

" Set 3 lines to the cursor - when moving vertically using j/k
set so=3

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

fixdel
set nu

" Increase history of ex commands
set history=200

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
set wrap "Wrap lines
"set nowrap

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
syntax on

" Enable included plugin matchit so % matches html tags and stuff
packadd! matchit

" work properly with clipboard
set clipboard=unnamed

" status line
" set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"
" set laststatus=2
" set noruler

" XML Folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax       

" map <leader>s :source ~/.vimrc<CR>
" nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" set path so :find always uses context of current file
set path=$PWD/**

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

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
  set syntax=xml
endfunction
command! XML call DoPrettyXML()

com! Json %!python -m json.tool
