# Ghostty, zsh and Neovim on Windows

My terminal setup for Windows. Ghostty runs zsh, and Neovim is opened from that
zsh, so the Neovim config is written for Ghostty and does not try to work
anywhere else.

Ghostty for Windows comes from
[polysius/ghostty-windows](https://github.com/polysius/ghostty-windows). Install
it first, from the zip on its releases page.

## Install

Open PowerShell and run:

```powershell
git clone https://github.com/polysius/dotfiles
cd dotfiles
powershell -ExecutionPolicy Bypass -File install.ps1
```

The script can be run again. It saves anything it replaces next to it with a
`.bak-<time>` suffix. It does these things in order:

1. Installs MSYS2 with winget if it is missing, then zsh, zoxide, fzf, gcc,
   make, ripgrep, fd and lazygit with pacman.
2. Installs Neovim with winget if it is missing.
3. Downloads the Courier Prime font into your per-user fonts folder. No
   registry change is needed.
4. Writes `%LOCALAPPDATA%\ghostty\config.ghostty` and copies the theme and the
   cursor shaders next to it.
5. Copies `zsh/zshrc` to `~/.zshrc`.
6. Copies `nvim/` to `%LOCALAPPDATA%\nvim` and lets Neovim install its plugins,
   language servers, formatters and Tree-sitter parsers. The parsers are
   compiled, which takes a few minutes.

Then open Ghostty. It starts zsh, and `nvim` starts Neovim.

## Ghostty

| Setting | Value |
| --- | --- |
| Theme | Monokai Pro Spectrum |
| Background | `#11100F` |
| Cursor | `#F37021` |
| Font | Courier Prime, size 24, font-thicken on |
| Shell | MSYS2 zsh |
| Cursor effects | cursor warp and ripple |

The cursor shaders are `cursor_warp.glsl` and `ripple_cursor.glsl` from
[sahaj-b/ghostty-cursor-shaders](https://github.com/sahaj-b/ghostty-cursor-shaders)
(MIT, license included). They are not part of the 0xhckr shader pack. The ripple
uses the cursor color instead of its original gray-blue.

## zsh

`~/.zshrc` puts the MSYS2 tools on PATH, enables completion and a large shared
history, and sets up zoxide (`z`, `zi`) and fzf (Ctrl-T files, Ctrl-R history,
Alt-C folders). The native Windows builds of zoxide and fzf print Windows line
endings, so the file strips them before zsh reads the output. It also replaces
zoxide's `__zoxide_pwd`, which is broken in zoxide's MSYS template.

## Neovim

The leader key is space. Press it and wait to see every key, or press
`<leader>?` for the keys of the current buffer.

| Area | Plugin | Keys |
| --- | --- | --- |
| Plugin manager | lazy.nvim | `:Lazy` |
| Theme | monokai-pro.nvim (spectrum, transparent background) | |
| Syntax | nvim-treesitter (c, cpp, python, rust, lua and more) | |
| Language servers | nvim-lspconfig, mason | `gd`, `K`, `grr`, `<leader>ca`, `<leader>cr` |
| Completion | blink.cmp | Enter accepts, `Ctrl-n` and `Ctrl-p` move |
| Fuzzy finder | telescope.nvim | `<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fr` |
| Formatters | conform.nvim, format on save | `<leader>cf` |
| Git | gitsigns, fugitive, lazygit | `]h`, `[h`, `<leader>gs`, `<leader>gg`, `<leader>gl` |
| File navigation | neo-tree, oil | `<leader>e`, `-` |
| Keymap discovery | which-key | `<leader>` |
| Status line | lualine | |

Servers: clangd (C, C++), pyright and ruff (Python), rust-analyzer (Rust) and
lua-language-server. Formatters: clang-format, ruff, rustfmt and stylua. Mason
installs them. rustfmt comes from `rustup component add rustfmt`, which the
install script runs when rustup is present.

What is tuned for Ghostty:

* True color is always on, and the background is transparent so Ghostty's
  `#11100F` and its shaders show through.
* The `Cursor` highlight is `#F37021` for every mode, so the cursor looks the
  same inside and outside Neovim and the cursor shaders follow it.
* Nerd Font icons are on. Ghostty draws the symbols itself, so Courier Prime
  needs no patched version.
* The clipboard is the system clipboard. Over SSH, copying goes through
  Ghostty's OSC 52 support.
* Neovim says so once when `TERM_PROGRAM` is not `ghostty`.

## Layout

```
install.ps1                      the installer
ghostty/config.ghostty.template  Ghostty config, paths filled in by the installer
ghostty/shaders/                 cursor warp and ripple shaders
ghostty/themes/                  Monokai Pro Spectrum
zsh/zshrc                        becomes ~/.zshrc
nvim/                            becomes %LOCALAPPDATA%\nvim
```
