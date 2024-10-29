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

  local cursor_stack = player.cursor_stack
  --- @type ItemIDAndQualityIDPair?
  local item_id = player.cursor_ghost --[[@as ItemIDAndQualityIDPair?]]
  if not item_id and cursor_stack and cursor_stack.valid_for_read then
    item_id = { name = cursor_stack.prototype, quality = cursor_stack.quality }
  end
  if not item_id then
    return
  end

  local recipes = prototypes.get_recipe_filtered({
    { filter = "has-product-item", elem_filters = { { filter = "name", name = item_id.name.name } } },
  })
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
