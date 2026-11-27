-- Monokai Pro Spectrum, with the Ghostty background and cursor color.
return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "spectrum",
        -- Ghostty paints the #11100F background (and its shaders draw over
        -- it), so Neovim leaves its own background transparent.
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = false },
          type = { italic = false },
          storageclass = { italic = false },
          structure = { italic = false },
          parameter = { italic = false },
          annotation = { italic = false },
          tag_attribute = { italic = false },
        },
        override = function()
          return {
            -- Same orange as the cursor in the Ghostty config.
            Cursor = { bg = "#F37021", fg = "#11100F" },
            lCursor = { bg = "#F37021", fg = "#11100F" },
            TermCursor = { bg = "#F37021", fg = "#11100F" },
            CursorLineNr = { fg = "#F37021", bold = true },
          }
        end,
      })
      vim.cmd.colorscheme("monokai-pro")
    end,
  },
}
