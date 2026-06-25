local function code_review(opts)
  local base = opts.args ~= '' and opts.args or nil

  if not base then
    -- detect default branch
    local result = vim.fn.systemlist('git rev-parse --abbrev-ref origin/HEAD 2>/dev/null')
    if vim.v.shell_error ~= 0 or #result == 0 then
      result = vim.fn.systemlist('git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null')
    end
    if #result > 0 then
      base = result[1]:match('/?([^/]+)$')
    else
      base = 'main'
    end
  end

  local log = vim.fn.systemlist(
    string.format('git log --reverse --pretty=format:"%%h %%s" %s..HEAD', vim.fn.shellescape(base))
  )
  if vim.v.shell_error ~= 0 or #log == 0 then
    vim.notify('CodeReview: no commits found between ' .. base .. ' and HEAD', vim.log.levels.WARN)
    return
  end

  local qf_items = {}
  for _, line in ipairs(log) do
    local sha, msg = line:match('^(%x+)%s+(.+)$')
    if sha then
      table.insert(qf_items, {
        text = sha .. ' ' .. msg,
        module = sha,
      })
    end
  end

  vim.fn.setqflist({}, 'r', {
    title = 'CodeReview: ' .. base .. '..HEAD',
    items = qf_items,
  })

  local target_win = vim.api.nvim_get_current_win()

  vim.cmd('copen')
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  local qf_win = vim.api.nvim_get_current_win()
  local qf_buf = vim.api.nvim_get_current_buf()

  local function open_commit(sha)
    vim.api.nvim_set_current_win(target_win)
    local prev_buf = vim.api.nvim_get_current_buf()
    local prev_buf_name = vim.api.nvim_buf_get_name(prev_buf)
    local prev_is_empty = prev_buf_name == ''
      and not vim.bo[prev_buf].modified
      and (vim.api.nvim_buf_get_lines(prev_buf, 0, -1, false)[1] or '') == ''
    local prev_is_fugitive = prev_buf_name:match('^fugitive://')

    vim.cmd('Git show ' .. sha)
    local new_win = vim.api.nvim_get_current_win()

    if new_win ~= target_win then
      vim.api.nvim_win_close(target_win, false)
      target_win = new_win
    end

    if (prev_is_empty or prev_is_fugitive) and vim.api.nvim_buf_is_valid(prev_buf) then
      vim.api.nvim_buf_delete(prev_buf, { force = true })
    end

    vim.api.nvim_set_current_win(qf_win)
  end

  vim.keymap.set('n', '<CR>', function()
    local item = vim.fn.getqflist()[vim.fn.line('.')]
    if item and item.module and item.module ~= '' then
      open_commit(item.module)
    end
  end, { buffer = qf_buf, noremap = true, silent = true })

  -- auto-open the first commit
  open_commit(qf_items[1].module)
end

vim.api.nvim_create_user_command('CodeReview', code_review, {
  nargs = '?',
  desc = 'Open quickfix list of commits between <base> (default: origin default branch) and HEAD',
})

-- strip trailing whitespace on save
-- https://stackoverflow.com/questions/77747363/remove-white-spaces-added-in-nvim-on-save
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
  desc = 'Trim trailing white spaces',
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      callback = function()
        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})
