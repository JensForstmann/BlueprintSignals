-- Temporary blueprint support
local Tempprint = {}


function Tempprint.set_signals_blueprint(player, current_tick)
    -- Makes a note of the item the player is currently holding.  If the cursor stack is cleaned, the item is removed.
    local stack = player.cursor_stack

    if not (stack.valid and stack.valid_for_read and stack.type == 'blueprint' and stack.item_number ~= 0) then return end

    local pdata = global.playerdata[player.index]
    if not pdata then
        pdata = {}
        global.playerdata[player.index] = pdata
    end

    pdata.temporary_item = {name=stack.name, item_number=stack.item_number, tick=current_tick}

    return true
end


function Tempprint.keep_signals_blueprint(player, current_tick)
    local player_data = global.playerdata[player.index]

    -- Bail out if signals blueprint has not been stored or if we have just finished creating it.
    if not (player_data and player_data.temporary_item) or player_data.temporary_item.tick == current_tick then
        return
    end

    -- Keep the signals blueprint.
    player_data.temporary_item = nil
end


function Tempprint.destroy_signals_blueprint(player, event)
    local pdata = global.playerdata[player.index]
    if not (pdata and pdata.temporary_item) then return end  -- No temporary item to clear
    local tempitem = pdata.temporary_item

    local stack = player.cursor_stack
    if not (stack.valid and stack.valid_for_read and stack.type == 'blueprint' and stack.item_number ~= 0) then return end

    if stack.name == tempitem.name and stack.item_number == tempitem.item_number then
        stack.clear()
    end

    pdata.temporary_item = nil
    return true
end


script.on_event(
        "BlueprintSignals_cleared_cursor_proxy",
        function(event) return Tempprint.destroy_signals_blueprint(game.players[event.player_index], event) end
)


local function keep_signals_blueprint_handler(event)
    return Tempprint.keep_signals_blueprint(game.players[event.player_index], event.tick)
end


Tempprint.events = {
    [defines.events.on_player_configured_blueprint] = keep_signals_blueprint_handler,
    [defines.events.on_player_cursor_stack_changed] = keep_signals_blueprint_handler,
    [defines.events.on_player_set_quick_bar_slot] = keep_signals_blueprint_handler
}


return Tempprint
