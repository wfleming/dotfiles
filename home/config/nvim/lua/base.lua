vim.cmd("autocmd!")
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.cmd("filetype plugin indent on")  -- load file type plugins + indentation

vim.opt.showcmd = true                     -- display incomplete commands
vim.opt.history = 1000                     -- keep 1000 lines of command line history
vim.opt.visualbell = true                  -- turn off auditory bell
vim.opt.autoread = true                    -- refresh file if changed outside of vim
vim.opt.clipboard:append { "unnamedplus" } -- for system pastboard integration

vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.number = true
vim.opt.ruler = true

-- Whitespace
vim.opt.listchars = "trail:.,tab:>-,extends:>,precedes:<"
vim.opt.textwidth = 100
vim.opt.colorcolumn = "+1"
vim.opt.formatoptions:remove({"t"})
vim.opt.wrap = false -- don't wrap lines
vim.opt.tabstop = 2 -- a tab is two spaces
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- use spaces, not tabs
vim.opt.backspace = {"indent", "eol", "start"}  -- backspace through everything in insert mode

-- Searching
vim.opt.hlsearch = true    -- highlight matches
vim.opt.incsearch = true   -- incremental searching
vim.opt.ignorecase = true  -- searches are case insensitive...
vim.opt.smartcase = true   -- ... unless they contain at least one capital

-- Fold by syntax highlighting by default
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99

-- Preview :substitute changes
vim.opt.inccommand = "split"

-- look for tags file from ctags in the git dir
vim.opt.tags:append { ".git/tags" }

-- color scheme
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

-- status line
require('lualine').setup({
  options = {
    theme = 'gruvbox',
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_c = { { 'filename'; path = 1 } },
  },
})

-- colorizing color vars
require('colorizer').setup({'css', 'sass', 'javascript'}, { css = true })
