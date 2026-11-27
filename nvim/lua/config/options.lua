vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ghostty draws Nerd Font symbols itself, so icons always work.
vim.g.have_nerd_font = true

local o = vim.o

-- Ghostty supports true color, so the colors below are exact.
o.termguicolors = true

-- Block cursor in normal mode, bar while typing, underline when replacing.
-- The Cursor highlight (orange, set in the theme file) gives all of them the
-- same color as the Ghostty cursor, and Ghostty's cursor shaders follow it.
o.guicursor = table.concat({
  "n-v-c-sm:block-Cursor",
  "i-ci-ve:ver25-Cursor",
  "r-cr-o:hor20-Cursor",
}, ",")

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.mouse = "a"
o.showmode = false -- the status line shows the mode
o.splitright = true
o.splitbelow = true
o.winborder = "rounded"
o.pumheight = 12

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.undofile = true
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 400 -- which-key pops up after this long

o.list = true
o.listchars = "tab:» ,trail:·,nbsp:␣"

-- Share the system clipboard. Windows has a native provider. Over SSH there
-- is none, so Ghostty's OSC 52 support is used for copying instead.
o.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- Use Git for Windows' shell tools only when asked; the default shell is fine.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
