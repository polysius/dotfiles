local group = vim.api.nvim_create_augroup("user", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Flash the text that was yanked",
  callback = function() vim.hl.on_yank() end,
})

-- Reopen a file where it was closed.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lines = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Two spaces are the norm in these languages.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "lua", "json", "yaml", "toml", "markdown" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- This setup is made for Ghostty. Say so once if it runs somewhere else.
if vim.env.TERM_PROGRAM ~= "ghostty" then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = function()
      vim.notify("This config is tuned for Ghostty; colors and cursor may differ here.", vim.log.levels.WARN)
    end,
  })
end
