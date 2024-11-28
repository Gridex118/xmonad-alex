require("lazy").setup({

    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            require('ui.tokyonight')
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    {
        "rcarriga/nvim-notify",
    },

    {
        "nvim-lualine/lualine.nvim",
        after = "tokyonight.nvim",
        event = "BufEnter",
        config = function()
            require('ui.lualine')
        end,
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        after = "tokyonight.nvim",
        event = "BufEnter",
        config = function ()
            require("ui.bufferline")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require('functionality.lsp')
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        config = function()
            require('functionality.cmp')
        end,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
    },

    {
        "hrsh7th/cmp-buffer",
    },

    {
        "hrsh7th/cmp-path",
    },

    {
        "hrsh7th/cmp-cmdline",
    },

    {
        "saadparwaiz1/cmp_luasnip",
    },

    {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        config = function ()
            require("functionality.snippets")
        end,
    },

    {
        "Gridex118/neovim-snippets",
        config = function ()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    {
        "ggandor/leap.nvim",
        event = "BufEnter",
        config = function ()
            require('functionality.leap')
        end,
    },

    {
        "kylechui/nvim-surround",
        version = '*',
        event = "VeryLazy",
        config = function()
            require('nvim-surround').setup {}
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('functionality.treesitter')
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim treesitter',
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function ()
            require('ui.telescope')
        end,
        event = "VimEnter",
    },

    {
        "nvim-lua/plenary.nvim",
    },

    {
        "BurntSushi/ripgrep",
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup {}
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require('mason-lspconfig').setup {}
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        after = "tokyonight.nvim",
        config = function()
            require('ui.indent_blankline')
        end,
    },

    {
        "stevearc/oil.nvim",
        config = function ()
            require("functionality.oil")
        end,
    },

    {
        "nanotee/zoxide.vim",
    },

    {
        "guns/vim-sexp",
        after = "BufEnter",
    },

    {
        "Olical/conjure",
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<space>T",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics",
            },
        },
    },

    {
        "jiangmiao/auto-pairs",
    },

})
