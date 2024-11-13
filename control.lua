local function can_read(item_stack)
    return item_stack and item_stack.valid and item_stack.valid_for_read
end

local function get_active_bp_from_stack(player, item_stack)
    if not (item_stack and item_stack.valid and item_stack.valid_for_read) then
        player.print({ "BlueprintSignals_continued.error-cannot-read-item" })
        return nil
    end

    if item_stack.is_blueprint then
        return { item_stack }
    end

    if item_stack.is_blueprint_book then
        local inventory = item_stack.get_inventory(defines.inventory.item_main)
        if item_stack.active_index == nil or #inventory == 0 then
            -- active blueprint book is empty
            return {}
        end
        return get_active_bp_from_stack(player, inventory[item_stack.active_index])
    end

    player.print({ "BlueprintSignals_continued.error-no-blueprint" })
    return nil
end

local function get_all_blueprints_from_stack(player, item_stack)
    local bps = {}
    local has_read_error = false
    local function collect_bps_recursive(item_stack_inner)
        if not can_read(item_stack) then
            has_read_error = true
            return nil
        end
        if item_stack_inner.is_blueprint then
            table.insert(bps, item_stack_inner)
            return nil
        end
        if item_stack_inner.is_blueprint_book then
            local inventory = item_stack_inner.get_inventory(defines.inventory.item_main)
            for i = 1, #inventory do
                collect_bps_recursive(inventory[i])
            end
        end
    end

    if can_read(item_stack) then
        if item_stack.is_blueprint or item_stack.is_blueprint_book then
            collect_bps_recursive(item_stack)
        else
            player.print({ "BlueprintSignals_continued.error-no-blueprint" })
            return nil
        end
    else
        has_read_error = true
    end

    if has_read_error then
        player.print({ "BlueprintSignals_continued.error-cannot-read-item" })
        return nil
    end

    return bps
end

local function increment_item(item_list, name, quality, count)
    if quality == nil then
        quality = "normal"
    end

    if type(quality) ~= "string" then
        quality = quality.name
    end

    if count == nil then
        count = 1
    end

    for _, item in pairs(item_list) do
        if item.name == name and item.quality == quality then
            item.count = item.count + count
            return
        end
    end

    table.insert(item_list, { name = name, quality = quality, count = count })
end

local function convert_bps(player, bps)
    if not bps then
        return
    end

    -- collect needed items

    local needed_items = {}

    for _, bp in pairs(bps) do
        for _, ctb in pairs(bp.cost_to_build) do
            increment_item(needed_items, ctb.name, ctb.quality, ctb.count)
        end
    end

    if #needed_items == 0 then
        player.print({ "BlueprintSignals_continued.error-empty-blueprint" })
        return
    end

    -- create constant combinators

    local signals_per_combinator = player.mod_settings["BlueprintSignals_continued_signal-limit"].value
    local current_combinator = 1
    local current_signal = 1
    local output_entities = {}

    for _, entity in pairs(needed_items) do
        local cc = output_entities[current_combinator]
        if cc == nil then
            cc = {
                entity_number = current_combinator,
                name = "constant-combinator",
                position = { x = current_combinator - 0.5, y = 0.5 },
                control_behavior = {
                    sections = {
                        sections = {
                            {
                                index = 1,
                                filters = {}
                            }
                        },
                    },
                },
            }
            output_entities[current_combinator] = cc
        end

        cc.control_behavior.sections.sections[1].filters[current_signal] = {
            index = current_signal,
            name = entity.name,
            quality = entity.quality,
            comparator = "=",
            count = entity.count,
        }

        current_signal = current_signal + 1
        if signals_per_combinator > 0 and current_signal > signals_per_combinator then
            current_combinator = current_combinator + 1
            current_signal = 1
        end
    end

    -- add wire connections

    for curr = 2, #output_entities do
        local cc1 = output_entities[curr - 1]
        local cc2 = output_entities[curr + 0]
        if cc1.wires == nil then
            cc1.wires = {}
        end
        if cc2.wires == nil then
            cc2.wires = {}
        end
        if player.mod_settings["BlueprintSignals_continued_connect-red"].value then
            table.insert(cc1.wires, {
                cc1.entity_number,
                defines.wire_connector_id.circuit_red,
                cc2.entity_number,
                defines.wire_connector_id.circuit_red
            })
        end
        if player.mod_settings["BlueprintSignals_continued_connect-green"].value then
            table.insert(cc1.wires, {
                cc1.entity_number,
                defines.wire_connector_id.circuit_green,
                cc2.entity_number,
                defines.wire_connector_id.circuit_green
            })
        end
    end

    -- create blueprint

    if not player.clear_cursor() or not player.cursor_stack.valid then
        player.print({ "BlueprintSignals_continued.error-cannot-create-blueprint" })
        return
    end

    local stack = player.cursor_stack
    stack.set_stack("blueprint")
    stack.set_blueprint_entities(output_entities)
    stack.label = "Blueprint Signals"
    player.cursor_stack_temporary = player.mod_settings["BlueprintSignals_continued_temporary-signals-bp"].value
end

local function on_event(event_name, player_index)
    local player = game.players[player_index]
    if event_name == "BlueprintSignals_continued_convert-blueprint" then
        convert_bps(player, get_active_bp_from_stack(player, player.cursor_stack))
    elseif event_name == "BlueprintSignals_continued_convert-blueprint-book" then
        convert_bps(player, get_all_blueprints_from_stack(player, player.cursor_stack))
    end
end

script.on_event(defines.events.on_lua_shortcut, function(event)
    on_event(event.prototype_name, event.player_index)
end)


script.on_event("BlueprintSignals_continued_convert-blueprint", function(event)
    on_event("BlueprintSignals_continued_convert-blueprint", event.player_index)
end)

script.on_event("BlueprintSignals_continued_convert-blueprint-book", function(event)
    on_event("BlueprintSignals_continued_convert-blueprint-book", event.player_index)
end)
