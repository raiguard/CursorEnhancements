local util = require("scripts.util")

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

  -- TODO: We can't craft with quality because this doesn't return the selected quality.
  -- Add this to the API.
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

  local recipes = util.get_selected_recipes(selected)
  if not recipes then
    return
  end

  for _, recipe in pairs(recipes) do
    local craftable_count = player.cheat_mode and math.huge or player.get_craftable_count(recipe.name) --[[@as uint]]
    if craftable_count == 0 then
      goto continue
    end
    local main_product = recipe.main_product or recipe.products[1]
    if not main_product then
      goto continue
    end
    local craft_count_setting = player.mod_settings["cen-quick-craft-count"].value --[[@as uint]]
    local main_product_amount = main_product.amount
    if not main_product_amount then
      goto continue
    end
    local craft_count = math.min(craftable_count, math.ceil(craft_count_setting / main_product_amount) --[[@as uint]])
    player.begin_crafting({ recipe = recipe.name, count = craft_count })
    -- Language server and formatter don't like a label after break...
    do
      break
    end
    ::continue::
  end
end

local quick_craft = {}

quick_craft.events = {
  ["cen-quick-craft"] = on_quick_craft,
}

return quick_craft
