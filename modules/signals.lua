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
    local bp = Util.get_blueprint( player.cursor_stack )
    if not (bp and bp.is_blueprint_setup()) then
        return
    end

    if not bp then
        player.print( {'bpsignals.error-no_blueprint'} )
        log( {'bpsignals.error-no_blueprint'} )
        return
    end
    if not bp.is_blueprint_setup() then
        player.print( {'bpsignals.error-invalid'} )
        log( {'bpsignals.error-invalid'} )
        return
    end

    local entities = bp.get_blueprint_entities()
    local tiles = bp.get_blueprint_tiles()
    
    local numEntities = 0
    local numTiles    = 0

    local map = {}

    local eCount = 0
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
    local cCount = math.ceil( mCount / slots )
    
    -- player.clear_console()
    -- player.print( "Entities: "    .. eCount )
    -- player.print( "Tiles: "       .. tCount )
    -- player.print( "Combinators: " .. cCount )
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
        for i = 1, 18 do
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
    
    local name  = bp.name
    local icons = bp.blueprint_icons
    local label = bp.label
    local color = bp.label_color
    
    if not player.clear_cursor() then
        player.print( "[bps] Error: Unable to clear the cursor.")
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