-- A list of parser names, or "all" (the five listed parsers should always be installed)
local ensureInstalled = {
	"bash",
	"c",
	"css",
	"javascript",
	"json",
	"lua",
	"make",
	"query",
	"rust",
	"php",
	"scss",
	"go",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
	"dockerfile",
	"markdown",
	"markdown_inline"
}

return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		priority = 1000,
		build = ':TSUpdate',
		branch = 'main',
		config = function()
			local treesitter = require('nvim-treesitter');

			-- The old master branch compiled parsers into the plugin directory
			-- itself and they survive the branch switch since git does not track
			-- them. Being on the runtimepath they shadow the parsers the main
			-- branch installs into site/parser, so delete any leftovers
			local pluginDir = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
			if vim.uv.fs_stat(pluginDir .. '/parser') then
				vim.fn.delete(pluginDir .. '/parser', 'rf')
				vim.fn.delete(pluginDir .. '/parser-info', 'rf')
			end

			treesitter.install(ensureInstalled);

			-- The main branch only manages parser installation, highlighting is
			-- started per buffer through the builtin vim.treesitter
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('TreesitterStart', {}),
				callback = function(event)
					local language = vim.treesitter.language.get_lang(event.match)
					if not language then
						return
					end

					if vim.tbl_contains(treesitter.get_installed(), language) then
						vim.treesitter.start(event.buf, language)
					elseif vim.tbl_contains(treesitter.get_available(), language) then
						-- Automatically install missing parsers when entering buffer
						treesitter.install({ language }):await(function(err)
							if not err and vim.api.nvim_buf_is_valid(event.buf) then
								vim.treesitter.start(event.buf, language)
							end
						end)
					end
				end,
			})
		end
	},
}
