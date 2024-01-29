local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

----------------------------------------------------------------
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
})

----------------------------------------------------------------
lspconfig.pyright.setup({
	capabilities = capabilities,
})

----------------------------------------------------------------
lspconfig.tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
	end,
})

----------------------------------------------------------------
lspconfig.html.setup({
	capabilities = capabilities,
	on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
	end,
})

----------------------------------------------------------------
lspconfig.cssls.setup({
	capabilities = capabilities,
	on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
	end,
})

----------------------------------------------------------------
lspconfig.nil_ls.setup({
	capabilities = capabilities,
	cmd = { "nil" },
	settings = {
		['nil'] = {
			formatting = {
				command = { "nixpkgs-fmt" },
			},
		},
	},
})

----------------------------------------------------------------
lspconfig.yamlls.setup({
	capabilities = capabilities,
	settings = {
		yaml = {
			schemas = {
				kubernetes = "/*.yaml",
			},
		},
	},
	on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = true
	end,
})

----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
local efmprettier = {
	{
		formatStdin = true,
		formatCommand = "prettier --stdin-filepath ${INPUT}",
	}
}
lspconfig.efm.setup({
	filetypes = {
		"css",
		"html",
		"javascript",
		"typescript",
		"python",
	},
	init_options = {
		documentFormatting = true
	},
	settings = {
		languages = {
			css = efmprettier,
			html = efmprettier,
			javascript = efmprettier,
			typescript = efmprettier,
			python = {
				{
					formatStdin = true,
					formatCommand = "black --quiet -",
				},
			},
		},
	},
})

----------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(e)
		for _, client in pairs(vim.lsp.buf_get_clients(e.buf)) do
			if client.supports_method("textDocument/formatting") then
				return vim.lsp.buf.format()
			end
		end
	end
})
