<#
.SYNOPSIS
  Sets up Ghostty, zsh and Neovim for Windows the way this repository describes.

.DESCRIPTION
  Run it from a clone of the repository:
    powershell -ExecutionPolicy Bypass -File install.ps1

  It installs MSYS2 (for zsh, zoxide, fzf, gcc, ripgrep, fd and lazygit) and
  Neovim if they are missing, downloads the Courier Prime font, copies the
  Ghostty config with its theme and cursor shaders, copies the zsh and Neovim
  configs, then lets Neovim install its plugins, language servers, formatters
  and Tree-sitter parsers. Existing files are saved next to the new ones with
  a .bak suffix before they are replaced. The script can be run again.

  Ghostty itself comes from https://github.com/polysius/ghostty-windows.

.PARAMETER SkipPackages
  Do not install MSYS2, Neovim or their packages.
.PARAMETER SkipNvimSetup
  Copy the Neovim config but do not install plugins and tools.
#>
[CmdletBinding()]
param(
    [switch]$SkipPackages,
    [switch]$SkipNvimSetup
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$msys = 'C:\msys64'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Write-Step($text) { Write-Host "== $text" -ForegroundColor Cyan }

# Move an existing file or folder out of the way before it is replaced.
function Save-Backup($path) {
    if (Test-Path $path) {
        Move-Item $path "$path.bak-$stamp"
        Write-Host "   kept the old one as $path.bak-$stamp"
    }
}

function Invoke-Msys($command) {
    & "$msys\usr\bin\bash.exe" -lc $command
    if ($LASTEXITCODE -ne 0) { throw "MSYS2 command failed: $command" }
}

# --- Packages -----------------------------------------------------------

if (-not $SkipPackages) {
    Write-Step 'MSYS2'
    if (-not (Test-Path "$msys\usr\bin\pacman.exe")) {
        winget install --id MSYS2.MSYS2 --source winget --scope user --accept-package-agreements --accept-source-agreements --silent
        if (-not (Test-Path "$msys\usr\bin\pacman.exe")) { throw "MSYS2 did not install to $msys." }
    }
    # zoxide and fzf are not in the msys repository, so they come from ucrt64.
    $packages = @(
        'zsh'
        'mingw-w64-ucrt-x86_64-zoxide'
        'mingw-w64-ucrt-x86_64-fzf'
        'mingw-w64-ucrt-x86_64-gcc'
        'mingw-w64-ucrt-x86_64-make'
        'mingw-w64-ucrt-x86_64-ripgrep'
        'mingw-w64-ucrt-x86_64-fd'
        'mingw-w64-ucrt-x86_64-lazygit'
    )
    Invoke-Msys ("pacman -Sy --noconfirm --needed " + ($packages -join ' '))

    Write-Step 'Neovim'
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
        winget install --id Neovim.Neovim --source winget --accept-package-agreements --accept-source-agreements --silent
        Write-Host '   Neovim was installed. Open a new terminal if the next steps cannot find nvim.'
    }
}

# --- Font ---------------------------------------------------------------

Write-Step 'Courier Prime font'
$fontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
New-Item -ItemType Directory -Force $fontDir | Out-Null
foreach ($style in 'Regular', 'Bold', 'Italic', 'BoldItalic') {
    $target = Join-Path $fontDir "CourierPrime-$style.ttf"
    if (-not (Test-Path $target)) {
        $url = "https://raw.githubusercontent.com/google/fonts/main/ofl/courierprime/CourierPrime-$style.ttf"
        Invoke-WebRequest $url -OutFile $target
    }
}

# --- Ghostty ------------------------------------------------------------

Write-Step 'Ghostty config'
$ghosttyDir = Join-Path $env:LOCALAPPDATA 'ghostty'
New-Item -ItemType Directory -Force (Join-Path $ghosttyDir 'shaders'), (Join-Path $ghosttyDir 'themes') | Out-Null
Copy-Item (Join-Path $repo 'ghostty\shaders\*') (Join-Path $ghosttyDir 'shaders') -Force
Copy-Item (Join-Path $repo 'ghostty\themes\*') (Join-Path $ghosttyDir 'themes') -Force

$config = Join-Path $ghosttyDir 'config.ghostty'
Save-Backup $config
$text = Get-Content (Join-Path $repo 'ghostty\config.ghostty.template') -Raw
$text = $text.Replace('@CONFIG_DIR@', ($ghosttyDir -replace '\\', '/')).Replace('@USERPROFILE@', $env:USERPROFILE)
Set-Content $config $text -Encoding utf8

# --- zsh ----------------------------------------------------------------

Write-Step 'zsh config'
$zshrc = Join-Path $env:USERPROFILE '.zshrc'
Save-Backup $zshrc
Copy-Item (Join-Path $repo 'zsh\zshrc') $zshrc

# --- Neovim -------------------------------------------------------------

Write-Step 'Neovim config'
$nvimDir = Join-Path $env:LOCALAPPDATA 'nvim'
Save-Backup $nvimDir
Copy-Item (Join-Path $repo 'nvim') $nvimDir -Recurse

if (-not $SkipNvimSetup) {
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) { throw 'nvim is not on PATH. Open a new terminal and run this again.' }
    if (Get-Command rustup -ErrorAction SilentlyContinue) { rustup component add rustfmt }

    # gcc, rg, fd and lazygit live in MSYS2. The Neovim config adds this folder
    # itself, and it is added here for the headless runs below.
    $env:PATH = "$env:PATH;$msys\ucrt64\bin"
    $env:TERM_PROGRAM = 'ghostty'

    Write-Step 'Neovim plugins'
    nvim --headless '+Lazy! sync' +qa

    Write-Step 'Language servers and formatters'
    nvim --headless +MasonToolsInstallSync +qa

    Write-Step 'Tree-sitter parsers (this compiles them and takes a few minutes)'
    $install = "lua require('nvim-treesitter').install({'c','cpp','python','rust','lua','vim','vimdoc','query','bash','json','toml','yaml','markdown','markdown_inline','cmake','make','gitcommit','diff','regex'}):wait(900000)"
    nvim --headless "+$install" +qa
}

Write-Host ''
Write-Host 'Done. Open Ghostty, then run nvim from the prompt.' -ForegroundColor Green
