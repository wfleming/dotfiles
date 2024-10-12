local fzf_lua = require("fzf-lua")

fzf_lua.setup()

vim.keymap.set("n", "<leader>f",
  function()
    fzf_lua.git_files({ cmd = "git ls-files --cached --modified --others --exclude-standard"})
  end,
  { desc = "FZF Git Files" }
)

vim.keymap.set("n", "<leader>b",
  function()
    -- todo not navigable with arrows like files?
    fzf_lua.buffers()
  end,
  { desc = "FZF current buffers" }
)

vim.keymap.set("n", "<leader>t",
  function()
    fzf_lua.tags()
  end,
  { desc = "FZF tags" }
)
