local Util    = require('util')
local actions = require('actions')
local mod_gui = require('mod-gui')

local GUI = {}

-- Generate sorted action list.
local sorted_actions = {}
for _, action in pairs(actions) do
    sorted_actions[#sorted_actions + 1] = action
end
table.sort(sorted_actions, function(a, b) return a.order < b.order end)


GUI.sorted_actions = sorted_actions


-- function GUI.setup(player)
    -- local flow = mod_gui.get_frame_flow(player)
    -- if flow.BPEX_Button_Flow then
        -- flow.BPEX_Button_Flow.destroy()
    -- end
    -- local parent

    -- for _, action in ipairs(sorted_actions) do
        -- if action.icon and player.mod_settings[action.visibility_setting].value then
            -- if not parent then
                -- parent = flow.add {
                    -- type = "flow",
                    -- name = "BPEX_Button_Flow",
                    -- enabled = true,
                    -- style = "slot_table_spacing_vertical_flow",
                    -- direction = "vertical"
                -- }
            -- end
            -- button = parent.add{
                -- name = action.name,
                -- type = "sprite-button",
                -- style = (action.shortcut_style and "shortcut_bar_button_" .. action.shortcut_style) or "shortcut_bar_button",
                -- sprite = action.name,
                -- tooltip = { "controls." .. action.name },
                -- enabled = true,
            -- }
        -- end
    -- end
    -- GUI.update_visibility(player, true)

    -- return parent  -- Might be nil if never created.
-- end

function GUI.setup(player)
    -- Retrieve flow element that contains the mod buttons.
    local button_flow = mod_gui.get_button_flow(player)

    -- Destroy existing buttons.
    for _, action in ipairs(sorted_actions) do
        if button_flow[action.name] then
            button_flow[action.name].destroy()
        end
    end

    -- Create action buttons.
    for _, action in ipairs(sorted_actions) do
        if action.icon and player.mod_settings[action.visibility_setting].value then
            local button = button_flow.add{
                name    = action.name
               ,type    = "sprite-button"
               ,style   = (action.shortcut_style and "shortcut_bar_button_" .. action.shortcut_style) or "shortcut_bar_button"
               ,sprite  = action.name
               ,tooltip = { "controls." .. action.name }
               ,enabled = true
            }
        end
    end

    GUI.update_visibility(player, true)
end

function GUI.update_visibility(player, force)
    local pdata = global.playerdata[player.index]
    if not pdata then
        pdata = {}
        global.playerdata[player.index] = pdata
    end

    local bp = (Util.get_blueprint(player.cursor_stack))
    local enabled = (bp and bp.is_blueprint_setup()) and true or false
    local was_enabled = pdata.buttons_enabled

    if (not force and was_enabled ~= nil and enabled == was_enabled) then
        return  -- No update needed.
    end

    for _, action in pairs(actions) do
        local button = mod_gui.get_button_flow(player)[action.name]
        if button then
            button.visible = enabled
        end
    end

    for name, action in pairs(actions) do
        if action.icon then
            player.set_shortcut_available(name, enabled)
        end
    end

    pdata.buttons_enabled = enabled
end


function GUI.on_configuration_changed(data)
    local frame_flow

    if not data.mod_changes["BlueprintSignals_continued"] then
        return
    end

    -- 0.5.0, button moved into better-fitting mod button flow
    -- element. Some additional logic needs to be employed to avoid
    -- destroying the flow element if it is in use by Blueprint
    -- Extensions or its successor.
    for _, player in pairs(game.players) do
        frame_flow = mod_gui.get_frame_flow(player)
        if frame_flow.BPEX_Button_Flow then
            if not (game.active_mods["BlueprintExtensions"] or game.active_mods["Kux-BlueprintExtensions"]) then
                frame_flow.BPEX_Button_Flow.destroy()
            else
                for _, action in pairs(actions) do
                    frame_flow.BPEX_Button_Flow[action.name].destroy()
                    player.print("Destroying action: " .. action.name)
                end
            end
        end
    end
end

return GUI
