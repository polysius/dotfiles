-- File navigation: a tree on the left, plus telescope for jumping by name.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "File tree" },
      { "<leader>E", "<cmd>Neotree float reveal<cr>", desc = "File tree (float)" },
      { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Changed files" },
    },
    opts = {
      popup_border_style = "rounded",
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { hide_dotfiles = false, hide_gitignored = true },
      },
      window = { width = 34, mappings = { ["<space>"] = "none" } },
    },
  },

  -- Edit the file system like a buffer: press - in any file.
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "-", "<cmd>Oil<cr>", desc = "Parent folder (oil)" } },
    opts = {
      default_file_explorer = false, -- the tree stays the default for directories
      view_options = { show_hidden = true },
    },
  },
}
