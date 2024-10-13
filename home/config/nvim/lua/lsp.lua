local util = require('util')
local lspconfig = require('lspconfig')
local lspcontainers = require('lspcontainers')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.solargraph.setup({
  on_new_config = function(new_config, new_root_dir)
    base_cmd = lspcontainers.command('solargraph', { root_dir = new_root_dir })
    new_config.cmd = util.list_concat(base_cmd, {'/usr/bin/solargraph', 'stdio'})
  end,
  capabilities = capabilities,
})

lspconfig.pylsp.setup({
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = lspcontainers.command('pylsp', { root_dir = new_root_dir })
  end,
  capabilities = capabilities,
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
})
