-- Tree-sitter parsers are built with gcc (from MSYS2) and the tree-sitter CLI
-- (installed by Mason, see lsp.lua).
local parsers = {
  "c", "cpp", "python", "rust", "lua", "vim", "vimdoc", "query",
  "bash", "json", "toml", "yaml", "markdown", "markdown_inline",
  "cmake", "make", "gitcommit", "diff", "regex",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- Installing is asynchronous and does nothing for parsers that are
      -- already there. It needs the tree-sitter CLI, so wait for it to exist.
      if vim.fn.executable("tree-sitter") == 1 and vim.fn.executable("gcc") == 1 then
        ts.install(parsers)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          -- Highlighting only starts when a parser exists for the file type.
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
