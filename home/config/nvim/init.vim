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
let g:airline_extensions = ['branch']

"" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"" vim.fzf
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
let g:fzf_buffers_jump = 1
let g:fzf_preview_window = ['down:40%:hidden', 'ctrl-/']
nnoremap <leader>f :GFiles<cr>
nnoremap <leader>b :Buffers<cr>

""""""""" Stock VIM config """"""""""""""""""

set termguicolors
syntax enable                " enable syntax highlighting
syntax sync minlines=100
filetype plugin indent on    " load file type plugins + indentation

set showcmd                  " display incomplete commands
set directory=~/.config/nvim/tmp/  " damn .swp files
set history=1000             " keep 1000 lines of command line history
set visualbell               " turn off auditory bell
set autoread                 " refresh file if changed outside of vim
set clipboard+=unnamedplus   " for system pastboard integration

"" color scheme
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

"" show line #/cursor column
set nocursorline
set nocursorcolumn
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

"" look for tags file from ctags in the git dir
set tags+=.git/tags

""""""""""" NeoVim term settings """""""""""""""""""

"" space-e to exit insert mode of term
tnoremap <Leader>e <C-\><C-c>

""""""""""" Commands, etc. """""""""""""""""

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
