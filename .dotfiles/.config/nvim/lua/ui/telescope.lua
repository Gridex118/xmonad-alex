require('telescope').setup {
    defaults = {
        theme = "center",
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "descending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
        },
    },
}
