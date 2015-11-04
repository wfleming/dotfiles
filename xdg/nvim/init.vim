""""""""" pathogen load & setup """""""""""""

execute pathogen#infect()

""""""""" Stock VIM config """"""""""""""""""

syntax enable                   " enable syntax highlighting
filetype plugin indent on       " load file type plugins + indentation

set showcmd                     " display incomplete commands
set directory=~/.vim/tmp/       " damn .swp files
set history=1000                " keep 100 lines of command line history
set visualbell                  " turn off auditory bell
set autoread                    " refresh file if changed outside of vim

" color scheme
set background=dark
colorscheme solarized

"" show line #/cursor column
set number
set ruler

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital
