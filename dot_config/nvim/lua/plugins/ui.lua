return {
    { "lukas-reineke/indent-blankline.nvim" },
    { "nvim-tree/nvim-web-devicons",        lazy = true },
    { "MunifTanjim/nui.nvim",               lazy = true },
    { "folke/tokyonight.nvim" },
    { "romainl/vim-dichromatic" },
    { "patstockwell/vim-monokai-tasty" },
    { "phanviet/vim-monokai-pro" },
    {
        "EdenEast/nightfox.nvim",
        config = function()
            vim.cmd([[colorscheme nightfox]])
        end,
        opts = {
            pallettes = {
                all = {
                    red     = "#cc3311",
                    green   = "#228833",
                    yellow  = "#ccbb44",
                    blue    = "#0077bb",
                    magenta = "#ee3377",
                    cyan    = "#33bbee",
                    orange  = "#ee7733",
                    --pink    = ""
                }
            }
        }
    },
    { "ryanoasis/vim-devicons" },
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        },
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper'
            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}
