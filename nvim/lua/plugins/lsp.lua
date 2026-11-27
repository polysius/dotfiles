-- Language servers for C, C++, Python and Rust, installed by Mason.
return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    lazy = false,
    opts = { ui = { border = "rounded" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    opts = {
      ensure_installed = {
        -- Tools other plugins call.
        "tree-sitter-cli",
        "clang-format",
        "stylua",
        -- Servers that mason-lspconfig does not list by lspconfig name.
        "clangd",
        "pyright",
        "ruff",
        "rust-analyzer",
        "lua-language-server",
      },
      run_on_start = true,
      start_delay = 500,
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Completion capabilities for every server.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = { analysis = { typeCheckingMode = "standard" } },
        },
      })

      -- Ruff lints and formats; Pyright does types and hover.
      vim.lsp.config("ruff", {
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      -- Servers are started for the file types they handle. mason-lspconfig
      -- only enables the ones Mason has installed.
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = { "clangd", "pyright", "ruff", "rust_analyzer", "lua_ls" },
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        underline = true,
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          -- K, grn, gra, grr and gri are built in to Neovim.
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cs", vim.lsp.buf.signature_help, "Signature help")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },

  { "mason-org/mason-lspconfig.nvim", lazy = true },
}
