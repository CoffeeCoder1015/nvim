# LazyVim Port Backlog

Goal: recreate the useful LazyVim behaviors locally without re-importing
`LazyVim/LazyVim` as a runtime dependency. Each completed slice should land as
its own git commit.

## 0. Baseline

- [x] Resolve the dirty worktree before starting the port.
- [x] Commit the standalone baseline: `70f99bc chore: checkpoint standalone nvim baseline`.

## 1. Project Root Behavior

- [x] Replace `opt.autochdir = true` with an explicit root helper.
- [x] Detect roots from attached LSP clients, `.git`, project markers, and cwd.
- [x] Add a `:NvimRoot` command that reports or switches to the detected root.
- [x] Expose `root()` and `git_root()` helpers for other config modules.
- [x] Wire root helpers into terminals, lazygit, pickers, Neo-tree, and lualine.

## 2. Picker Ergonomics

- [x] Decide whether the main picker layer is Telescope or Snacks picker.
- [x] Add root and cwd variants for files, grep, oldfiles, buffers, and config files.
- [x] Add hidden/no-ignore affordances where supported.
- [x] Add git file/log/status pickers.
- [x] Add Trouble handoff from picker results where useful.
- [x] Add `vim.ui.select`/`vim.ui.input` integration if keeping Telescope.

## 3. LSP Defaults

- [x] Move from Kickstart-style LSP mappings to a shared LazyVim-style default map set.
- [x] Configure global diagnostics: signs, virtual text, underline, severity sorting.
- [x] Add workspace file-operation capabilities.
- [x] Add capability-gated mappings for hover, signature help, definitions, references,
      rename, code actions, source actions, organize imports, codelens, and file rename.
- [x] Enable inlay hints when supported.
- [x] Enable LSP folding when supported.
- [x] Preserve local clangd offset-encoding behavior.

## 4. Formatting Controls

- [x] Replace unconditional Conform format-on-save with global and buffer toggles.
- [x] Add format commands and format-info command.
- [x] Add `formatexpr` equivalent for `gq`.
- [x] Preserve explicit formatter choices for Lua, shell, and fish.
- [x] Keep LSP formatting fallback behavior.

## 5. Snippets

- [x] Choose LuaSnip, native snippets, or mini.snippets.
- [x] Load friendly snippets and local `snippets/` through Blink native snippets.
- [x] Wire Blink to the native snippet preset.
- [x] Stop active snippets on Escape.
- [x] Remove stale `lazyvim.json` expectations once the choice is explicit.

## 6. Indent Guides

- [x] Choose Snacks indent or `indent-blankline.nvim`.
- [x] Keep Snacks indent enabled instead of adding `indent-blankline.nvim`.
- [x] Add exclusions for dashboards, help, terminal, lazy, Mason, Trouble, and similar UIs.
- [x] Add an indent-guide toggle.

## 7. Neo-tree

- [x] Add root and cwd explorer mappings.
- [x] Add filesystem, buffers, and git status sources.
- [x] Follow the current file without binding the explorer to cwd.
- [x] Enable file watchers where appropriate.
- [x] Add copy path, system open, preview, and rename hooks.
- [x] Refresh git status after lazygit.
- [x] Handle directory arguments on startup.

## 8. Statusline And UI Feedback

- [x] Add root display and pretty path to lualine.
- [x] Add Noice command/mode status.
- [x] Add lazy update status only if update checking remains manual and non-noisy.
- [x] Add gitsigns diff status.
- [x] Add DAP status when DAP is loaded.
- [x] Add Trouble symbol breadcrumb.
- [x] Keep macro recording feedback visible.
- [x] Decide whether to enable Snacks statuscolumn.

## 9. Snacks And Noice Glue

- [x] Re-enable Noice markdown overrides if compatible with current Neovim/plugins.
- [x] Add picker-aware notification history.
- [x] Add dashboard picker bridge.
- [x] Decide whether Snacks scroll should be enabled.
- [x] Add profiler toggles if useful.
- [x] Keep VSCode-Neovim conditionals explicit.

## 10. Language Extras

- [x] Port Go-specific LSP, format, lint, and existing DAP behavior as needed.
- [x] Port Rust-specific behavior as needed.
- [x] Port C/C++ clangd behavior as needed.
- [x] Defer TypeScript behavior until a real TypeScript workflow needs it.
- [x] Defer Python behavior until a real Python workflow needs it.
- [x] Add other language extras only when a real workflow needs them.

## 11. Utility Extras

- [x] Add Gitsigns toggle.
- [x] Add Trouble-aware quickfix navigation.
- [x] Add `GrugFarWithin`.
- [x] Consider `mini.hipatterns` for color and pattern highlighting.
- [x] Consider project picker, REST client, startuptime, Octo/GitHub, Chezmoi, or GitUI
      only if they match real workflows.
