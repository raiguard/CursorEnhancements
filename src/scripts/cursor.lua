local cursor = {}

local constants = require("constants")

local player_data = require("scripts.player-data")

function cursor.check_stack(cursor_stack, cursor_ghost)
  if cursor_stack and cursor_stack.valid_for_read then
    return cursor_stack.name
  elseif cursor_ghost then
    return cursor_ghost.name
  else
    return
  end
end

function cursor.set_stack(player, cursor_stack, player_table, item_name)
  local spawn_item = player_table.settings.spawn_items_when_cheating and (player.cheat_mode or (player.controller_type == defines.controllers.editor))
  player_data.ensure_valid_inventory(player, player_table)
  local main_inventory = player_table.main_inventory
  local item_count = main_inventory.get_item_count(item_name)
  if item_count > 0 then
    player.clean_cursor()
    cursor_stack.set_stack{name=item_name, count=main_inventory.remove{name=item_name, count=game.item_prototypes[item_name].stack_size}}
    return true
  elseif spawn_item then
    player.clean_cursor()
    cursor_stack.set_stack{name=item_name, count=game.item_prototypes[item_name].stack_size}
    return true
  else
    local place_result = game.item_prototypes[item_name].place_result
    if place_result then
      player.clean_cursor()
      player_table.last_item = item_name
      player.cursor_ghost = item_name
      return true
    else
      return false
    end
  end
end

function cursor.scroll(player_index, direction)
  local player = game.get_player(player_index)
  local player_table = global.players[player_index]
  local cursor_stack = player.cursor_stack
  local current_item = cursor.check_stack(cursor_stack, player.cursor_ghost)

  if current_item then
    local item_data = global.default_registry[current_item]
    if item_data then
      local item_name = item_data[constants.direction_to_grade[direction]]
      if item_name then
        cursor.set_stack(player, cursor_stack, player_table, item_name)
      end
    end
  end
end

return cursor