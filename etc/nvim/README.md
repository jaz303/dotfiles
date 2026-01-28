# Jason's Janky nvim Config

## Shortcuts

These aren't all necessarily custom... more of an aide-memoire for me...

  - `<F2>` - rename (VSCode muscle memory...)
  - `<F12>` - goto definition (ditto...)
  - `=` - LSP reformat
  - `<C-l>` - redraw the screen, clear search

### Autocompletion/LSP stuff

  - `<C-Enter>` - LSP code actions
  - `<C-Space>` - summon autocompleter
  - `<C-{n,p}>` - next/previous autocompletion

### Buffer navigation

  - `<leader><leader>` - Telescope buffer switcher
  - `<leader><BS>` - Alternate buffer
  - `<leader>[` - Previous buffer
  - `<leader>]` - Next buffer
  - `<leader>b` - General buffer leader

### i3 Integration

  - `<M-Enter>` - pop up a terminal, working dir = workspace root
  - `<M-S-Enter>` - pop up a terminal, working dir = active file dir
  - `<leader>gg` - pop up `lazygit` (Linux) or Sublime Merge (macOS)

## Editing

  - (I) `<C-BS>` - delete word
  - (N/I) - `<M-S-{Up,Down}>` - move line up/down

## Yank/Paste

  - `:%Y` - yank all lines (or any other range) to system clipboard
  - `:%P` - paste over given range from system clipboard (not currently working)

## Windows

Window numbering is derived on-demand based on geometry, increasing from left to right.

  - `<M-0>` - focus on Neotree, open if not visible
  - `<M-S-0>` - toggle Neotree
  - `<M-{1-4}>` - jump to window 1-4
  - `<M-S-{1-4}>` - move active buffer to window 1-4
  - `<M-{Left,Right}>` - cycle active window left/right (with wraparound)
  - `<M-=>` - equalize width of all windows
  - `<M-S-=>` - focus on active window (make it 70% of the available horizontal space)

In Neotree, pressing `{1-4}` will open file in the corresponding window (assumes target window exists).

