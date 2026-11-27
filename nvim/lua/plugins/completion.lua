return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- Enter accepts, Ctrl-n and Ctrl-p move, Ctrl-e closes.
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        menu = { border = "rounded" },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      -- The Lua matcher needs no downloaded binary, which keeps installs simple.
      fuzzy = { implementation = "lua", prebuilt_binaries = { download = false } },
    },
    opts_extend = { "sources.default" },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
