--- @class Util
local util = {}

--- @param player LuaPlayer
--- @return string?
function util.get_cursor_item(player)
  local cursor_stack = player.cursor_stack
  if not cursor_stack or not cursor_stack.valid_for_read then
    cursor_stack = {}
  end
  local cursor_ghost = player.cursor_ghost or {}
  return cursor_stack.name or cursor_ghost.name
end

--- @param selected SelectedPrototypeData?
--- @return string?
function util.get_selected_item(selected)
  if not selected then
    return
  end
  local type = selected.base_type
  if type == "item" then
    return selected.name
  elseif type == "entity" then
    local entity = game.entity_prototypes[selected.name]
    local item = (entity.items_to_place_this or {})[1]
    if item then
      return item.name
    end
  elseif type == "recipe" then
    local recipe = game.recipe_prototypes[selected.name]
    local product = recipe.products[1]
    if product and product.type == "item" then
      return product.name
    end
  end
end

--- @param selected SelectedPrototypeData?
--- @return LuaCustomTable<string, LuaRecipePrototype>?
function util.get_selected_recipes(selected)
  if not selected then
    return
  end
  if selected.base_type == "recipe" then
    return { game.recipe_prototypes[selected.name] }
  end

  local item = util.get_selected_item(selected)
  if not item then
    return
  end

  return game.get_filtered_recipe_prototypes({
    { filter = "has-product-item", elem_filters = { { filter = "name", name = item } } },
  })
end

--- @param player LuaPlayer
--- @return boolean
function util.is_cheating(player)
  if
    player.cheat_mode
    and not (player.controller_type == defines.controllers.god and script.active_mods["space-exploration"])
  then
    return true
  end
  return player.controller_type == defines.controllers.editor
end

--- @param player LuaPlayer
--- @param item string
--- @return boolean success
function util.set_cursor(player, item)
  local inventory = player.get_main_inventory()
  if not inventory then
    return false
  end
  local cursor_stack = player.cursor_stack
  if not cursor_stack or not player.clear_cursor() then
    return false
  end
  local inventory_stack, stack_index = inventory.find_item_stack(item)
  if not inventory_stack or not stack_index then
    local stack_size = game.item_prototypes[item].stack_size
    if util.is_cheating(player) and inventory.can_insert({ name = item, count = stack_size }) then
      inventory.insert({ name = item, count = stack_size })
      inventory_stack, stack_index = inventory.find_item_stack(item)
    else
      player.cursor_ghost = item
      return true
    end
  end
  --- @cast inventory_stack LuaItemStack
  --- @cast stack_index uint
  if not cursor_stack.transfer_stack(inventory_stack) then
    return false
  end
  local inventory_def
  if player.controller_type == defines.controllers.character then
    inventory_def = defines.inventory.character_main
  elseif player.controller_type == defines.controllers.editor then
    inventory_def = defines.inventory.editor_main
  elseif player.controller_type == defines.controllers.god then
    inventory_def = defines.inventory.god_main
  end
  player.hand_location = { inventory = inventory_def, slot = stack_index }
  return true
end

return util
