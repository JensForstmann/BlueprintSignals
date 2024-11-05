data:extend {
    {
        type = "custom-input",
        name = "BlueprintSignals_continued_convert-blueprint",
        key_sequence = "CONTROL + ALT + S",
        order = "b[blueprints]-s[bps]-a-a-1",
        action = "lua",
    },
    {
        type = "custom-input",
        name = "BlueprintSignals_continued_convert-blueprint-book",
        key_sequence = "CONTROL + SHIFT + ALT + S",
        order = "b[blueprints]-s[bps]-a-a-2",
        action = "lua",
    },
    {
        type = "shortcut",
        name = "BlueprintSignals_continued_convert-blueprint",
        localised_name = { "controls.BlueprintSignals_continued_convert-blueprint" },
        localised_description = { "controls-description.BlueprintSignals_continued_convert-blueprint" },
        associated_control_input = "BlueprintSignals_continued_convert-blueprint",
        action = "lua",
        toggleable = false,
        icons = {
            {
                icon = "__BlueprintSignals_continued__/graphics/icon-bp-64.png",
                icon_size = 64,
            }
        },
        small_icons = {
            {
                icon = "__BlueprintSignals_continued__/graphics/icon-bp-64.png",
                icon_size = 64,
            }
        },
        style = "default",
        order = "b[blueprints]-s[bps]-a-a-1",
    },
    {
        type = "shortcut",
        name = "BlueprintSignals_continued_convert-blueprint-book",
        localised_name = { "controls.BlueprintSignals_continued_convert-blueprint-book" },
        localised_description = { "controls-description.BlueprintSignals_continued_convert-blueprint-book" },
        associated_control_input = "BlueprintSignals_continued_convert-blueprint-book",
        action = "lua",
        toggleable = false,
        icons = {
            {
                icon = "__BlueprintSignals_continued__/graphics/icon-bp-book-64.png",
                icon_size = 64,
            }
        },
        small_icons = {
            {
                icon = "__BlueprintSignals_continued__/graphics/icon-bp-book-64.png",
                icon_size = 64,
            }
        },
        style = "default",
        order = "b[blueprints]-s[bps]-a-a-2",
    },
}
