autocmd!
let mapleader = "\<Space>"

"" airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''
let g:airline_extensions = []
let g:airline_extensions = ['branch']

"" vim.fzf
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
let g:fzf_buffers_jump = 1
let g:fzf_preview_window = ['down:40%:hidden', 'ctrl-/']
nnoremap <leader>f :GFiles --cached --modified --others --exclude-standard<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>

"" vimiwiki
let g:vimwiki_list = [{'path': '~/Dropbox/notes', 'syntax': 'markdown', 'ext': '.md'}]

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
set textwidth=100 colorcolumn=+1 formatoptions-=t
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
tnoremap <Leader>e <C-\><C-n>

""""""""""" Commands, etc. """""""""""""""""

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

" Use FZF to open a wiki page by name or create a new one
function! OpenOrCreateNoteCallback(lines)
  " if the query found a match, there are 2 lines (query, then match)
  " if there was no match, there's only 1 line (query)

  let root = g:vimwiki_list[0]["path"]
  if len(a:lines) > 1
    let target = root . "/" . a:lines[1]
  else
    let target = root . "/" . a:lines[0]
    if target !~ "\.md$" "Add an extension if I didn't type one
      let target = target . ".md"
    endif
  end
  execute "edit" fnameescape(target)
endfunction
command -bang OpenOrCreateNote call fzf#vim#files(g:vimwiki_list[0]["path"], {"sinklist": funcref("OpenOrCreateNoteCallback"), "options": ["--print-query"]})
nnoremap <Leader>wo :OpenOrCreateNote<CR>

""""""""""" File-type settings """"""""""""""""

augroup vimrc
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8
augroup END

augroup mutt
  autocmd FileType mail setlocal textwidth=72 | normal! }
augroup END
