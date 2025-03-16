return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "javascript",
                    "arduino", "asm",
                    "bash",
                    "c_sharp", "clojure", "cmake", "cpp", "csv", "cuda",
                    "d", "devicetree", "diff", "dockerfile",
                    "elixir",
                    "glsl", "go", "gomod", "gosum", "gotmpl", "graphql",
                    "html",
                    "ini",
                    "java", "jq", "jsdoc", "json", "json5",
                    "kotlin",
                    "linkerscript",
                    "make",
                    "nasm", "nginx", "nim",
                    "objc", "ocaml", "odin",
                    "pascal", "php", "prolog", "proto", "python",
                    "ruby", "rust",
                    "scss", "sql", "ssh_config", "supercollider", "svelte",
                    "terraform", "toml", "tsx", "typescript",
                    "udev",
                    "v", "vala", "verilog", "vhdl", "vim", "vue",
                    "xml",
                    "yaml",
                    "zig"
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true }
            })
        end
    }
}

