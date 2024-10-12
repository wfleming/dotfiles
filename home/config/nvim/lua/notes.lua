-- config/commands for my notes in dropbox
vim.g.notes_root = "~/Dropbox/notes/"

vim.keymap.set(
  'n', '<leader>w<leader>w',
  function()
    print("OpenTodayDiary")
    local path = vim.g.notes_root .. "diary/" .. os.date("%Y-%m-%d.md")
    vim.cmd("edit " .. path)
  end,
  { desc = "Open today's diary" }
)

local fzf_lua = require("fzf-lua")
vim.keymap.set(
  'n', '<leader>wo',
  function()
    fzf_lua.files({ cwd = vim.g.notes_root })
  end,
  { desc = "FZF diary pages" }
)
