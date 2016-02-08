""""""""" pathogen load & setup """""""""""""

autocmd!
let mapleader = "\<Space>"
execute pathogen#infect()

"" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"" nerdtree
let NERDTreeCaseSensitiveSort = 1
nnoremap <leader>d :NERDTreeToggle \| :silent NERDTreeMirror<CR>

""""""""" Stock VIM config """"""""""""""""""

syntax enable                " enable syntax highlighting
filetype plugin indent on    " load file type plugins + indentation

set showcmd                  " display incomplete commands
set directory=~/.config/nvim/tmp/  " damn .swp files
set history=1000             " keep 100 lines of command line history
set visualbell               " turn off auditory bell
set autoread                 " refresh file if changed outside of vim
set clipboard=unnamedplus,unnamed  " for system pastboard integration
"this mapping is acting weird: the cursor moves on exiting insert
inoremap jk <ESC>hhh    " use letters to get out of insert mode

"" color scheme
colorscheme distinguished

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

"" Golang
autocmd FileType go set noexpandtab tabstop=8

""""""""""" NeoVim term settings """""""""""""""""""

"" space-e to exit insert mode of term
tnoremap <Leader>e <C-\><C-c>

""""""""""" Commands, etc. """""""""""""""""

"" ctrlp (fuzzy file search)
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
nnoremap <leader>f :CtrlP<cr>

" Code Climate CLI
let g:vimcodeclimate_analyze_cmd = '/usr/local/bin/codeclimate analyze --dev '
nmap <Leader>a :CodeClimateAnalyzeCurrentFile<CR>

"" Tab behavior: indent at beginning of line, otherwise autocomplete
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

"" strip trailing whitespace on save
function! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call StripTrailingWhitespaces()
