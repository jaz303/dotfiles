# vim notes

Legend:
  - __*__ = customisation
  - __!__ = built in keybinding, but custom behaviour

## Basic Stuff
  - `.` - repeat last edit operation
  - `;` - repeat last motion operation (`f`, `t` etc)

## Editing
  - `J` - join current line with line below
  - `S` - substitute; in normal mode, clears current line and enters insert mode (with indentation). In visual mode this is overridden by vim-surround, but that's fine, because in visual mode `c` (change) does the same thing. Tip: use numeric prefix e.g. `5S` to change 5 lines... (need to add 1 to relative line numbers here)
  - `D` - delete to end of line - great for cutting end of line to paste elsewhere
  - `=` - format; works with motions e.g. `gg=G` moves to top, then formats to bottom of file.

When in visual mode, entering command mode prepopulates the command line with the range of the visual selection.

## Searching
  - `/` - enter search string (fwd)
  - `?` - enter search string (back)
  - `n` - next match (in backwards mode, this searches back the way)
  - `N` - previous match
  - __*__ `<C-l>` - clear search highlighting (also redraws)

## Navigating
  - `m[a-z]` to set a mark, `'[a-z]` to jump to that mark
  - `<C-i>` and `<C-o>` go fwd/back (mnemonic: `o` = old) through jumplist, don't really like this because it can take you unexpectedly to a different file. deally there would be a per-file internal jumplist and an external jumplist for keeping track of visited files, which could each be navigated independently. Changing buffers should always be a deliberate choice.
  - `zz` - centre around cursor
  - `gi` - go to last insert location and re-enter insert mode. This is useful, say, if you've had to scroll about to find something elsewhere.
  - `gg`/`G` - top/bottom of doc
  - `[x]G` - go to line x
  - `%` - jump to matching paren
  - `d%`, `y%`, `v%` etc - operations to matching paren
  - `<C-{u,d}>` - page up/down
  - `{H,M,L}` - top/middle/bottom of screen
  - `{`, `}` - "paragraph" back/fwd
  - `(`, `)` - "sentence" back/fwd
  - `_` - can move to start of line, similar to `^`; not identical though because it can accept a count

### Word-wise navigation

  - `e`, `w`, `b`, `ge` - go fwd/back to end/start of words
  - `E`, `W`, `B`, `gE` - go fwd/back to end/start of WORDs

word is delimited by non-keyword characters.
WORD is always delimited by whitespace.

## Treehopper
Use `m` to access Treehopper. This can be used in:
  - operator pending mode, e.g. `ym[x]` to yank the region denoted by char `x`
  - visual mode: use `m[x]` to visually select region denoted by char `x`

## Neotree
When Neotree is focused:
  - __*__ `1-8` - open selected file in the corresponding window
  - __*__ `y` - yank selected file path to register `"`
  - __*__ `Y` - yank selected file path to system clipboard

The yank operations present a menu to allow selection of relative path, full path, basename, etc.

Other helpers:
  - __*__ `\\` - focus on current file in Neotree
  - __*__ `|` - resize Neotree to fit content

## Commenting
  - (N) `gc[motion]` - toggle motion target
    - `gc6j`
    - `gcm[c]` - treehopper
  - (V) `gc` - toggle comment on selection
  - (N) `gcc` - toggle line comment

## Visual mode
  - `gv` - restore last visual selection
  - `o` - jump to other end of selection

## Yank relative without moving cursor
  - `:-36y` - single line
  - `:+10y` - single line
  - `:-10,-5y` - range (is there an easier way to do this?)

## Indentation
  - when in visual-block mode, use `>`/`<` to indent/outdent by one level. selection will be cleared. you can use counts to do multiple levels e.g. `2>`. if you need to do multiple indents without counting remember you can use `.` to repeat the last action.
  - i have also mapped `<C-,>` and `<C-.>` to perform indent/dedent in visual mode without clearing visual selection.

## System Clipboard
  - __*__ `<leader>y` - copy selection to system clipboard
  - __*__ `<leader>p`, `<leader>P` - paste system clipboard before/after

## Buffer management
  - __*__ `<leader><leader>` - Telescope buffers
  - __*__ `<leader><BS>` - switch to alternate buffer
  - __*__ `<leader>[`, `<leader>]` - switch to prev/next buffer
  - __*__ `<leader>bz` - delete all saved, hidden buffers
  - __*__ `<leader>b` - general buffer leader (see which-key for commands)
  - `:bd` or `:bd!` - delete buffer (latter variant discards changes). this will also close the window.

## Macros
  - `q[a-z]` - begin recording
  - `q` - stop recording
  - `@[a-z]` - execute
  - `@@` - repeat

## Git
  - `<leader>gg` - pop up lazygit in floating terminal (or Sublime Merge on macOS)
  - `<leader>gs[x]` - git stage, where `[x]` is:
    - `b` - stage buffer
    - `h` - stage hunk
    - `B` - reset buffer
    - `H` - reset hunk
  - `<leader>gt` - toggle line blame
  - `<leader>gw` - toggle word diff
  - `<leader>gb` - pop up git blame
  - `<leader>gd`, `<leader>gD` - diff

## [nvim-surround](https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt)

These are the basics; there is also specific stuff for adding function calls, and strings.

__Note:__ Using the right delimiter e.g. `]})>`, does not add space; using the left delimiter e.g. `[{(<`, adds space.

  - `ys` - normal mode - `ys{motion}{char}`
    - `ysiw"`
    - `yse[`
    - `yst;}`
  - `yss` - operates on the current line, e.g. `yss[`
  - `yS`, `ySS` - these variants place delimiter pair on new lines
  - `S` - visual, e.g. `S(`
  - `gS` - visual, place delimiters on new lines
  - `ds` - delete - e.g. `ds(` changes `(foo)` to `foo`
  - `cs` - change - e.g. `cs({` changes `(foo)` to `{foo}`
  - `cS` - change, place delimiters on new lines

### HTML Tags

`t` and `T` are triggers.

Examples:

  - `ysstdiv<CR>` - encloses the current line in `<div>...</div>`
  - `Sth1 id=foo<CR>` - encloses the selection in `<h1 id="foo">...</h1>`
  - `dst` - remove outer tag
  - `csth2` - change outer tag to `h2`, retaining attributes
  - `csTh3` - change outer tag to `h3`, removing attributes

### Functions

`f` is the trigger; e.g.

  - `ysiwfcall` - encloses in `call(...)`
  - `Sfcall` - encloses visual selection in `call(...)`
  - `dsf` - removes function call

## LSP

### Popups/floats

  - `K` - in normal mode, popup the hover box
  - __*__ `<leader>?` - diagnostics popup
  - __*__ `<leader>,` - signature help popup
  - __*__ `<leader>.` - general popup leader (use which-key for all options)
  - `"` - trigger which-key register list
  - `'`, `\`` - trigger which-key mark list

