-- lazy.nvim installs itself on first start.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Could not install lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Mason keeps language servers and formatters in its own folder. Putting the
-- MSYS2 tools on PATH here lets Neovim find gcc, rg, fd and lazygit even when
-- it was not started from the zsh that Ghostty runs.
local msys = "C:\\msys64\\ucrt64\\bin"
if vim.fn.isdirectory(msys) == 1 and not vim.env.PATH:find(msys, 1, true) then
  vim.env.PATH = vim.env.PATH .. ";" .. msys
end

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "monokai-pro" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  ui = { border = "rounded" },
})
