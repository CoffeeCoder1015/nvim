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

- [ ] Choose LuaSnip, native snippets, or mini.snippets.
- [ ] If LuaSnip: load friendly snippets and local `snippets/`.
- [ ] If LuaSnip: wire Blink to the LuaSnip preset.
- [ ] Stop active snippets on Escape.
- [ ] Remove stale `lazyvim.json` expectations once the choice is explicit.

## 6. Indent Guides

- [ ] Choose Snacks indent or `indent-blankline.nvim`.
- [ ] If using `indent-blankline.nvim`, disable Snacks indent.
- [ ] Add exclusions for dashboards, help, terminal, lazy, Mason, Trouble, and similar UIs.
- [ ] Add an indent-guide toggle.

## 7. Neo-tree

- [ ] Add root and cwd explorer mappings.
- [ ] Add filesystem, buffers, and git status sources.
- [ ] Follow the current file without binding the explorer to cwd.
- [ ] Enable file watchers where appropriate.
- [ ] Add copy path, system open, preview, and rename hooks.
- [ ] Refresh git status after lazygit.
- [ ] Handle directory arguments on startup.

## 8. Statusline And UI Feedback

- [ ] Add root display and pretty path to lualine.
- [ ] Add Noice command/mode status.
- [ ] Add lazy update status only if update checking remains manual and non-noisy.
- [ ] Add gitsigns diff status.
- [ ] Add DAP status when DAP is loaded.
- [ ] Add Trouble symbol breadcrumb.
- [ ] Keep macro recording feedback visible.
- [ ] Decide whether to enable Snacks statuscolumn.

## 9. Snacks And Noice Glue

- [ ] Re-enable Noice markdown overrides if compatible with current Neovim/plugins.
- [ ] Add picker-aware notification history.
- [ ] Add dashboard picker bridge.
- [ ] Decide whether Snacks scroll should be enabled.
- [ ] Add profiler toggles if useful.
- [ ] Keep VSCode-Neovim conditionals explicit.

## 10. Language Extras

- [ ] Port Go-specific LSP, format, lint, DAP, and test behavior as needed.
- [ ] Port Rust-specific behavior as needed.
- [ ] Port C/C++ clangd behavior as needed.
- [ ] Port TypeScript behavior as needed.
- [ ] Port Python behavior as needed.
- [ ] Add other language extras only when a real workflow needs them.

## 11. Utility Extras

- [ ] Add Gitsigns toggle.
- [ ] Add Trouble-aware quickfix navigation.
- [ ] Add `GrugFarWithin`.
- [ ] Consider `mini.hipatterns` for color and pattern highlighting.
- [ ] Consider project picker, REST client, startuptime, Octo/GitHub, Chezmoi, or GitUI
      only if they match real workflows.
