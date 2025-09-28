Moving the TODOs to its own file...

## Completion

  - [~] Automatic signature hints for calls - sort of working, but also sort of broken in Go... the blink.cmp feature is experimental though...
  - [~] Better formatting/more info in completion list - blink definitely looks better, still need to dive into customisation options
  - [ ] experiment with completion keybindings until i like them
  - [ ] better code actions menu - lspsaga maybe?

## Other Big Stuff

I've installed `trouble.nvim`. Looks cool but need to play about with the various functions. Also need to decide on what leader prefixes we're going to be using going forward; I'm learning towards:

  - `<leader>x` - diagnostics
  - `<leader>c` - general LSP querying
  - `<leader>g` - goto (inc. LSP based navigation)

Look at `flash.nvim` - could be better than Treehopper.

Look at `mini.ai` - advanced text objects including ars + function calls.

Look at `nvim-treesitter-textobjects`

Should I just bite the bullet and use `nvim-lspconfig` and `mason` rather than setting up all the LSP stuff manually? Could help with setting up new machines.

We should setup `T` to trigger/toggle a popup for the "best possible" guess at the __type definition__ under the cursor.

Investigate `lspsaga` plugin.

LLM integration
  - [mcphub.nvim](https://github.com/ravitemer/mcphub.nvim)
  - [CodeCompanion.nvim](https://codecompanion.olimorris.dev/)
  - [copilot.vim](https://github.com/github/copilot.vim)

## Small Stuff

  - [ ] `todo-comments.nvim` - colours are too bold/bright
  - [ ] `todo-comments.nvim` - add keybindings for navigation
  - [ ] need a shortcut to toggle Neotree through symbols, files, buffers, etc (although `trouble` might take care of this)
  - [ ] Auto imports for e.g. Go, TypeScript? At the moment I need to do `C-Enter` to summon the code-actions.

## Bugs

  - need to get block commenting working with `C-/` - seem to remember this was working on my desktop but not on the laptop.

## Misc other plugins to look into

  - `conform.nvim` - for formatting
  - `nvim-lint` -
  - [`grug-far.nvim`](https://www.lazyvim.org/plugins/editor#grug-farnvim) - search/replace in multiple files
  - `snipe`
  - `easymotion`
  - [hop.nvim](https://github.com/smoka7/hop.nvim)
  - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
  - [vim-fugitive](https://github.com/tpope/vim-fugitive)

## Plugins I'm Not Using

List of plugins I've decided not to use here, so I can remind myself later.

  - `mini.pairs` - I'm using autopairs and happy with it, plus a lot of people say they prefer autopairs anyway.
  - `harpoon`, `miniharp` - tried them, unconvinced

## shunt

Rewrite this plugin so it creates a window per item.
Add support for capturing types.
`nui` plugin might be a good starting point?

## Build system integration

Simplest way to do this is to lean on `make` and some predefined targets:

  - `make`
  - `make test`
  - `make debug`
  - `make run`

HOWEVER it would be good if we could get build feedback with clickable errors.
What about setting up breakpoints?
And it would be good if `make run` could run in a foreground terminal.

So it's not quite as simple as just "calling make".

Also - .env support

Once we've got something in place for this we can just assign `F5` - `F8` to these functions. Or maybe `<leader>p` for project or `<leader>m` for `make`.
