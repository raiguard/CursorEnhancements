local bounding_box = require("__flib__.bounding-box")

local util = require("scripts.util")

--- @param surface LuaSurface
--- @param cursor_position MapPosition
--- @return string?
local function get_tile_item(surface, cursor_position)
  -- Get tile
  local tile_area = bounding_box.from_position(cursor_position, true)
  local tile = surface.find_tiles_filtered({ area = tile_area })[1]
  if not tile or not tile.valid then
    return
  end

  --- @type LuaEntityPrototype|LuaTilePrototype
  local prototype = tile.prototype
  if prototype.collision_mask["water-tile"] then
    -- XXX: LuaCustomTable doesn't support next()
    for _, entity in pairs(game.get_filtered_entity_prototypes({ { filter = "type", type = "offshore-pump" } })) do
      prototype = entity
      break
    end
  end

  local items_to_place_this = prototype.items_to_place_this
  if not items_to_place_this then
    return
  end
  local item_to_place = items_to_place_this[1]
  if item_to_place then
    return item_to_place.name
  end
end

--- @param e EventData.CustomInputEvent
local function on_smart_pipette(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end

  -- Don't override base game logic
  local cursor_stack = player.cursor_stack
  if not cursor_stack or cursor_stack.valid_for_read or player.cursor_ghost or player.selected then
    return
  end

  local item = util.get_selected_item(e.selected_prototype) or get_tile_item(player.surface, e.cursor_position)
  if not item then
    return
  end

  if not util.set_cursor(player, item) then
    return
  end

  player.play_sound({
    path = "utility/smart_pipette",
  })
end

local smartpipette = {}

smartpipette.events = {
  ["cen-linked-smart-pipette"] = on_smart_pipette,
}

return smartpipette
