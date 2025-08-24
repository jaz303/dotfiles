# vim notes

Legend:
  - __*__ = customisation
  - __!__ = built in keybinding, but custom behaviour

## Basic Stuff
  - `.` - repeat last edit operation
  - `;` - repeat last motion operation (`f`, `t` etc)

## Editing
  - `J` - join current line with line below

## Searching
  - `/` - enter search string (fwd)
  - `?` - enter search string (back)
  - `n` - next match (in backwards mode, this searches back the way)
  - `N` - previous match
  - __*__ `<C-l>` - clear search highlighting (also redraws)

## Navigating
  - `m[a-z]` to set a mark, `'[a-z]` to jump to that mark
  - `<C-i>` and `<C-o>` go fwd/back (mnemonic: `o` = old) through jumplist, don't really like this because it can take you unexpectedly to a different file. Ideally there would be a per-file internal jumplist and an external jumplist for keeping track of visited files, which could each be navigated independently. Changing buffers should always be a deliberate choice.
  - `zz` - centre around cursor
  - `gi` - go to last insert location and re-enter insert mode. This is useful, say, if you've had to scroll about to find something elsewhere.

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

## Commenting
  - in visual mode, `gc` to toggle line comment
  - in normal mode, `gcc` to toggle line comment

## System Clipboard
  - __*__ `<leader>y` - copy selection to system clipboard
  - __*__ `<leader>p`, `<leader>P` - paste system clipboard before/after

## Buffer management
  - `:bd` or `:bd!` - delete buffer (latter variant discards changes). this will also close the window.

## Macros
  - `q[a-z]` - begin recording
  - `q` - stop recording
  - `@[a-z]` - execute

## LSP

### Popups/floats

  - `K` - in normal mode, popup the hover box
  - __*__ `<leader>?` - diagnostics popup
  - __*__ `<leader>,` - signature help popup
  - __*__ `<leader>.` - general popup leader (use which-key for all options)
