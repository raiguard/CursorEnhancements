local util = require("__CursorEnhancements__/scripts/util")

local crafting_controllers = {
  [defines.controllers.character] = true,
  [defines.controllers.god] = true,
}

--- @param e EventData.CustomInputEvent
local function on_quick_craft(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end

  if not crafting_controllers[player.controller_type] then
    return
  end

  local selected = e.selected_prototype
  if not selected then
    return
  end

  if selected.base_type == "entity" and selected.name == "entity-ghost" then
    -- Get ghost entity name
    local real_selected = player.selected
    if not real_selected or real_selected.name ~= "entity-ghost" then
      return
    end
    selected.name = real_selected.ghost_name
  end

  local recipe = util.get_selected_recipe(selected)
  if not recipe then
    return
  end

  local craft_count = player.mod_settings["cen-quick-craft-count"].value --[[@as uint]]
  player.begin_crafting({ recipe = recipe, count = craft_count })
end

local quick_craft = {}

quick_craft.events = {
  ["cen-quick-craft"] = on_quick_craft,
}

return quick_craft
