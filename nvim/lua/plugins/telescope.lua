-- Fuzzy finder. find_files uses fd and live_grep uses ripgrep, both from MSYS2.
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search text (ripgrep)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in file" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols in project" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
    },
    opts = {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        border = true,
        file_ignore_patterns = { "^.git/", "node_modules/", "target/", "build/" },
      },
      pickers = {
        find_files = { hidden = true },
      },
    },
  },
}
