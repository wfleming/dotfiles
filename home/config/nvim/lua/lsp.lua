local util = require('util')
local lspconfig = require('lspconfig')
local lspcontainers = require('lspcontainers')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', {
  root_markers = { '.git' },
})

local lsps = {
  {
    'solargraph',
    {
      capabilities = capabilities,
      filetypes = { 'ruby' },
      cmd = function(dispatchers, config)
        base_cmd = lspcontainers.command('solargraph', { root_dir = config.root_dir })
        cmd = util.list_concat(base_cmd, {'/usr/bin/solargraph', 'stdio'})
        return vim.lsp.rpc.start(cmd, dispatchers)
      end
    }
  },
  {
    'pylsp',
    {
      capabilities = capabilities,
      filetypes = { 'python' },
      cmd = function(dispatchers, config)
        cmd = lspcontainers.command('pylsp', { root_dir = new_root_dir })
        return vim.lsp.rpc.start(cmd, dispatchers)
      end,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = {'E501'},
              maxLineLength = 200
            }
          }
        }
      }
    }
  },
}

for _, lsp in pairs(lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)
    if config then
        vim.lsp.config(name, config)
    end
end
