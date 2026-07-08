vim.opt.guicursor = ''
vim.opt.nu = true
vim.opt.backupcopy = 'yes'

-- What does the line number shifting
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undo'
vim.opt.directory = os.getenv('HOME') .. '/.nvim/swaps'
vim.opt.backupdir = os.getenv('HOME') .. '/.nvim/backups'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true


vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
--[[ Experimental UI2: floating cmdline and messages
vim.o.cmdheight = 1
local ui2 = require("vim._core.ui2")
ui2.enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "msg",
	callback = function()
		local ui2 = require("vim._core.ui2")
		local win = ui2.wins and ui2.wins.msg
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_option_value(
				"winhighlight",
				"Normal:NormalFloat,FloatBorder:FloatBorder",
				{ scope = "local", win = win }
			)
		end
	end,
})

local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
	orig_set_pos(tgt)
	if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
		pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
			relative = "editor",
			anchor = "NE",
			row = 1,
			col = vim.o.columns - 1,
			border = "rounded",
		})
	end
end
--]]
vim.g.mapleader = ' '

-- Folds
vim.opt.foldmethod = 'marker'
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:_'

-- reload files changed outside vim
vim.opt.autoread = true
-- show the filename in the window titelbar
vim.opt.title = true

-- vertical split below
vim.opt.splitbelow = true
-- horizontal split to the right
vim.opt.splitright = true

-- disable mouse
vim.opt.mouse = ''

--[[vim.cmd([[
augroup templates
    autocmd BufNewFile *.vue 0r ~/.nvim/templates/sfc.vue
augroup END
\]\])
]] --

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd.normal({ args = { "g'\"" }, bang = true })
		end
	end
})

vim.g.netrw_keepdir = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "yaml", "yml" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})
