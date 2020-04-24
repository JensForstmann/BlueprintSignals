--- Actions for shortcut bar/etc.
local actions = {
    ["BlueprintSignals_convert"] = {
        icon = 7,
        key_sequence = "CONTROL + ALT + S",
        order = 'a-a',
        visibility_setting = 'BlueprintSignals_show-convert',
        shortcut_style = 'blue',
    }
}

for name, action in pairs(actions) do action.name = name end

return actions
