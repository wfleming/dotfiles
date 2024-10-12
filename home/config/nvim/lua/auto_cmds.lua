local vimrcGrp = vim.api.nvim_create_augroup("vimrc", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = muttGrp,
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
  end
})

local muttGrp = vim.api.nvim_create_augroup("mutt", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = muttGrp,
  pattern = "mail",
  callback = function()
    vim.opt_local.textwidth = 72
    vim.cmd("normal! }")
  end
})
