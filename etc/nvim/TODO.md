Moving the TODOs to its own file...

## Big Stuff

Completion/LSP stuff still isn't good enough. I tried coc, it's good but it feels like sailing against the tide as it basically replaces all of the built-in LSP stuff. Things I really want:

  - [ ] Golang auto imports
  - [x] Golang anonymous function completion
  - [~] Automatic signature hints for calls
    - sort of working, but also sort of broken in Go... the blink.cmp feature is experimental though...
  - [~] Better formatting/more info in completion list
    - blink definitely looks better, still need to dive into customisation options
  - [ ] experiment with completion keybindings until i like them

LLM integration

## Other peoples' configs

  - https://github.com/mcauley-penney/nvim/tree/main/lua/aucmd

## General

Auto imports for e.g. Go, TypeScript? At the moment I need to do `C-Enter` to summon the code-actions.

We have [gitsigns](https://github.com/lewis6991/gitsigns.nvim) installed, pretty good, need to look into customisation.

Need a shortcut to toggle Neotree through symbols, files, buffers, etc.

## Bugs

  - need to get block commenting working with `C-/` - seem to remember this was working on my desktop but not on the laptop.

## Misc plugins to look into

  - `nvim-treesitter-textobjects`
  - `snipe`
  - `easymotion`
  - [hop.nvim](https://github.com/smoka7/hop.nvim)
  - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
  - [vim-fugitive](https://github.com/tpope/vim-fugitive)

## Window Stuff

  - Ability to cycle Neotree through files/docsyms/git/buffers
    (or maybe distinct command for each?)

## Completion, LSP Floats, more

Look into [blink.cmp](https://github.com/saghen/blink.cmp).

Using `K` to trigger hover. It would be better if pressing it again closed the popup, rather than focus.
Look into the default LSP bindings; maybe remove the `K` binding and make our own function (should be an autocmd for LspAttach).

We should setup `T` to trigger/toggle a popup for the "best possible" guess at the __type definition__ under consideration.

Investigate `lspsaga` plugin.

## shunt

Rewrite this plugin so it creates a window per item.
Add support for capturing types.
`nui` plugin might be a good starting point?

## harpoon/miniharp

Tried these, unconvinced... will revisit.

## Autocompletion

Would be good if we got inline hints for call signatures.

## LLM Integration

  - [mcphub.nvim](https://github.com/ravitemer/mcphub.nvim)
  - [CodeCompanion.nvim](https://codecompanion.olimorris.dev/)
  - [copilot.vim](https://github.com/github/copilot.vim)

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
