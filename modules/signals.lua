local Util = require("util")
local actions = require('actions')
local Tempprint = require('modules/tempprint')

local Signals = {}

local function map_signals( map )
    local signals = {}
    local i = 1
    for k, v in pairs(map) do
        signals[i] = {
            count = v,
            index = 0,
            signal = { name = k, type = "item" }
        }
        i = i + 1
    end
    return signals
end

local function add_connections( player, connections, other_entity_number )
    connections          = connections or {}

    connections[1]       = connections[1] or {}
    connections[1].red   = connections[1].red   or {}
    connections[1].green = connections[1].green or {}

    if player.mod_settings["BlueprintSignals_connect-red"].value then
        connections[1].red[  #connections[1].red  +1] = {entity_id=other_entity_number}
    end
    if player.mod_settings["BlueprintSignals_connect-green"].value then
        connections[1].green[#connections[1].green+1] = {entity_id=other_entity_number}
    end

    return connections
end

function Signals.blueprint_to_signals(player, event, action)
    -- Set-up notification colors.
    local notification_color = {
        error = {1, 0, 0, 1},
        warning = {1, 1, 0, 1}
    }

    -- Bail out early if player is not holding a blueprint.
    if not player.is_cursor_blueprint() then
        player.print({'bpsignals.error-no_blueprint'}, notification_color.error )
        log( {'bpsignals.error-no_blueprint'} )
        return
    end

    -- Works for blueprints from both inventory and library.
    local entities = player.get_blueprint_entities() or {}

    -- Works only for blueprints from inventory.
    local blueprint = Util.get_blueprint(player.cursor_stack)

    if not blueprint then
        player.print({'bpsignals.warning-blueprint_library'}, notification_color.warning )
    end

    -- Fetch tiles from inventory blueprint.
    local tiles = blueprint and blueprint.get_blueprint_tiles() or {}

    -- Bail out if blueprint is empty (library blueprints with only tiles will also appear empty).
    if #entities == 0 and #tiles == 0 then
        player.print({'bpsignals.error-invalid'}, notification_color.error)
        log( {'bpsignals.error-invalid'} )
        return
    end

    local numEntities = 0
    local numTiles    = 0

    local map = {}

    local eCount = 0
    local modCount = 0
    local tCount = 0

    if entities then
        numEntities = #entities
        for _, entity in pairs(entities) do
            eCount = eCount + 1
            local item = game.entity_prototypes[entity.name].items_to_place_this[1]
            if type(item) == "string" then
                item = { name = item, count = game.item_prototypes[item].stack_size }
            end
            map[item.name] = (map[item.name] or 0) + item.count
            if entity.items then
                for item, count in pairs(entity.items) do
                    modCount = modCount + count
                    map[item] = (map[item] or 0) + count
                end
            end
        end
    end

    if tiles then
        numTiles = #tiles
        for _, tile in pairs(tiles) do
            tCount = tCount + 1
            local item = game.tile_prototypes[tile.name].items_to_place_this[1]
            if type(item) == "string" then
                item = { name = item, count = game.item_prototypes[item].stack_size }
            end
            map[item.name] = (map[item.name] or 0) + item.count
        end
    end

    local mCount = 0
    for _ in pairs(map) do mCount = mCount + 1 end

    local slots = game.entity_prototypes["constant-combinator"].item_slot_count
    if player.mod_settings["BlueprintSignals_signal-limit"].value > 0 then
        slots = math.min(slots, player.mod_settings["BlueprintSignals_signal-limit"].value)
    end
    local cCount = math.ceil( mCount / slots )

    -- player.clear_console()
    -- player.print( "Entities: "    .. eCount   )
    -- player.print( "Modules: "     .. modCount )
    -- player.print( "Tiles: "       .. tCount   )
    -- player.print( "Combinators: " .. cCount   )
    -- player.print( "----------" )

    -- for k, v in pairs(map) do player.print( k .. ": " .. v ) end

    -- for _, entity in pairs(entities) do
        -- log( serpent.block( entity ) )
        -- break
    -- end

    local signals = map_signals( map )
    local sCount = mCount
    local s = 0
    entities = {}
    for c = 1, cCount do
        local filters = {}
        for i = 1, slots do
            s = s + 1
            if s > sCount then break end
            filters[i] = signals[s]
            filters[i].index = i
        end
        entities[c] = {
            entity_number = c
           ,name = "constant-combinator"
           ,direction = defines.direction.north
           ,position = { x = c - math.ceil(cCount/2), y = 0 }
           ,control_behavior = { filters = filters }
        }
        if c > 1 then -- connect with previous combinator
            local b = c - 1
            entities[b].connections = add_connections( player, entities[b].connections, entities[c].entity_number )
            entities[c].connections = add_connections( player, entities[c].connections, entities[b].entity_number )
        end
    end

    -- Fallback icon if no icons are set on blueprint, normally required only in case of library blueprints.
    local fallback_icon = {
        signal = { type = "item", name = "constant-combinator" },
        index = 1
    }

    -- Read blueprint information with fallback in case of library blueprints.
    local name  = blueprint and blueprint.name or "blueprint"
    local icons = blueprint and blueprint.blueprint_icons or { fallback_icon }
    local label = blueprint and blueprint.label or "Blueprint"
    local color = blueprint and blueprint.label_color or nil

    if not player.clear_cursor() then
        player.print({'error-clear_cursor'}, notification_color.error)
        return
    end


    local stack = player.cursor_stack
    stack.set_stack( name )
    stack.set_blueprint_entities( entities )
    if icons then
        stack.blueprint_icons = icons
    end
    if label then
        stack.label = label .. " - Network Signals"
    end
    if color then
        stack.label_color = color
    end

    Tempprint.set_temporary( player )
end

actions['BlueprintSignals_convert'].handler = Signals.blueprint_to_signals

return Signals
