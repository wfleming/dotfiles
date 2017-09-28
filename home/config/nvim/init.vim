""""""""" pathogen load & setup """""""""""""

autocmd!
let mapleader = "\<Space>"
execute pathogen#infect()

"" airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''
let g:airline_extensions = []
let g:airline_extensions = ['branch', 'ctrlp']

"" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"" nerdtree
let NERDTreeCaseSensitiveSort = 1
nnoremap <leader>d :NERDTreeToggle \| :silent NERDTreeMirror<CR>

"" ctrlp
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_buffer_func = { 'enter': 'CtrlPBufferEnter', 'exit': 'CtrlPBufferExit' }

""""""""" Stock VIM config """"""""""""""""""

syntax enable                " enable syntax highlighting
filetype plugin indent on    " load file type plugins + indentation

set showcmd                  " display incomplete commands
set directory=~/.config/nvim/tmp/  " damn .swp files
set history=1000             " keep 1000 lines of command line history
set visualbell               " turn off auditory bell
set autoread                 " refresh file if changed outside of vim
set clipboard+=unnamedplus   " for system pastboard integration
"this mapping is acting weird: the cursor moves on exiting insert
inoremap jk <ESC>hhh    " use letters to get out of insert mode

"" color scheme
colorscheme meh

"" show line #/cursor column
set cursorline
set number
set ruler

"" Whitespace
set list listchars=trail:.,tab:>-,extends:>,precedes:<
set textwidth=80 colorcolumn=+1 formatoptions-=t
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital

" Fold by syntax highlighting by default
set foldmethod=syntax
set foldlevelstart=99

"" Preview :substitute changes (nvim only)
set inccommand=split

""""""""""" NeoVim term settings """""""""""""""""""

"" space-e to exit insert mode of term
tnoremap <Leader>e <C-\><C-c>

""""""""""" Commands, etc. """""""""""""""""

"" ctrlp buffer funcs
function! CtrlPBufferEnter()
  highlight CursorLine gui=NONE guibg=#424242 cterm=NONE ctermbg=8
endfunction
function! CtrlPBufferExit()
  highlight CursorLine gui=NONE guibg=NONE cterm=NONE ctermbg=NONE
endfunction

nnoremap <leader>f :CtrlP<cr>

" Code Climate CLI
nmap <Leader>aa :CodeClimateAnalyzeCurrentFile<CR>

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

""""""""""" File-type settings """"""""""""""""

augroup vimrc
  autocmd FileType go setlocal noexpandtab tabstop=8 shiftwidth=8
  autocmd FileType javascript let b:codeclimateflags='--engine eslint'
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8
  autocmd FileType ruby let b:codeclimateflags='--engine rubocop'
  autocmd FileType scss let b:codeclimateflags='--engine scss-lint'
augroup END

augroup mutt
  autocmd FileType mail setlocal textwidth=72 | normal! }
augroup END
