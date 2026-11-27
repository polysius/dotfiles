return {
  -- Press <leader> and wait: which-key lists what comes next.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      win = { border = "rounded" },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>x", group = "diagnostics" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Keymaps of this buffer" },
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Status line.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = {
          {
            -- The language servers attached to this buffer.
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, client.name)
              end
              return #names > 0 and (" " .. table.concat(names, ",")) or ""
            end,
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
