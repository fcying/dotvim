# Repository Instructions

## Scope
- This is a personal Neovim config, not a plugin/package project; root `snippets/package.json` only declares VSCode-style snippets and has no repo scripts.
- Main entrypoint is `init.lua`; plugin wiring lives in `lua/config/lazy.lua` and plugin specs under `lua/plugins/`.

## Runtime Model
- `init.lua` requires Neovim 0.12+ and prepends `vendor/` to `PATH` before loading plugins.
- All Neovim runtime state is redirected into `.run/` via `stdpath()` override: plugins, Mason packages, parsers, shada, undo, cache, and logs belong there and must not be committed.
- `lazy.nvim` installs itself into `.run/plugins/lazy.nvim`; there is no lockfile, and Lazy rocks/hererocks are disabled.
- Mason installs into `.run/mason` and uses `github:fcying/my-mason-registry` before the upstream registry.
- Tree-sitter parsers install into `.run/parsers`; headless startup waits for parser install and forces `CC=gcc` for `tree-sitter build`.

## Local Config Hooks
- User config is sourced from `~/.vimrc.local` if present.
- Zsh shell configuration is in `etc/zshrc`; supporting zsh files live under `etc/`.
- Project config is `.nvim.lua` or `.pvimrc`, found upward from root markers `.root`, `.git`, `.repo`, `.svn`; this repo has `.nvim.lua` adding `.vim_origin`, `vim_config`, and `.run` to `Option.dir`.
- `Option` is a global extension point defined in `lua/util.lua`; `Option.dir/file/mru/rg/lsp` extend defaults, not replace them.

## Verification Commands
- Config-load smoke test: `nvim --headless -u init.lua +qa`.
- Release-style plugin sync: `nvim --headless "+Lazy! sync" +qa`.
- Release vendor Mason installs: `nvim --headless -c 'MasonInstall --sync lua-language-server' -c qall` and `nvim --headless -c 'MasonInstall --sync clangd' -c qall`.
- There is no repo-local lint, typecheck, or test runner configured; prefer the headless smoke test after Lua config changes.

## Release Packaging
- `.github/workflows/release.yml` builds on pushes to `main`/`test`, nightly schedule, and manual dispatch.
- The release package copies only `init.lua`, `lua/`, `dict/`, `snippets/`, `vendor/`, and `etc/` into `~/.config/nvim`; keep required runtime files inside those paths unless the workflow is updated.
- `nvim_config_with_vendor.txz` also vendors `tree-sitter`, `rg`, `ctags`, `clangd`, and `lua-language-server`; `.run/cache` is deleted before packing.
