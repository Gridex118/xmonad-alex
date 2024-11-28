require('tokyonight').setup({
    style = "night",
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
    },
    on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
            bg = c.bg_dark,
            fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
            bg = c.bg_dark,
            fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
            bg = prompt,
        }
        hl.TelescopePromptBorder = {
            bg = prompt,
            fg = prompt,
        }
        hl.TelescopePromptTitle = {
            bg = prompt,
            fg = prompt,
        }
        hl.TelescopePreviewTitle = {
            bg = c.bg_dark,
            fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
            bg = c.bg_dark,
            fg = c.bg_dark,
        }
        hl.CursorLineNr = {
            bg = "#292e42",
            fg = "#737aa2"
        }
        hl.WinSeparator = {
            fg = "#3b4261",
        }
        hl.TabLineSel = {
            bg = "#1a1b26",
            fg = "#0db9d7"
        }
    end,
})
