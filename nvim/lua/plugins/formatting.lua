-- Formatters: clang-format (C, C++), ruff (Python), rustfmt (Rust), stylua (Lua).
-- Mason installs all of them except rustfmt, which comes with `rustup component add rustfmt`.
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        lua = { "stylua" },
      },
      -- Format when a file is saved. Turn it off with :let g:disable_autoformat = v:true
      format_on_save = function()
        if vim.g.disable_autoformat then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
