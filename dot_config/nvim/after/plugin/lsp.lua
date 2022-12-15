local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'gopls',
  'sumneko_lua',
  'bashls',
  'yamlls',
})
lsp.nvim_workspace()
lsp.setup()

local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	return
end

cmp.setup({
	sources = cmp.config.sources({
		{ name = 'path' },
		{ name = 'luasnip' },
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
		{ name = 'emoji' },
		{ name = 'nerdfont' },
	}, {
		{ name = 'buffer' },
	}),
	cmp.setup.cmdline('/', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	}),
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{
				name = 'cmdline',
				option = {
					ignore_cmds = { 'Man', '!' }
				}
			}
		})
	})
})
