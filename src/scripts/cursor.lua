local cursor = {}

local local_data = require("scripts.local-data")

function cursor.check_stack(cursor_stack, cursor_ghost, ghost_item)
  if cursor_stack and cursor_stack.valid_for_read then
    return cursor_stack.name
  elseif cursor_ghost then
    return ghost_item
  else
    return
  end
end

function cursor.scroll_items(player_index, list_index, direction)
  local player = game.get_player(player_index)
  local player_table = global.players[player_index]
  local player_local_data = local_data[player_index]
  local cursor_stack = player.cursor_stack
  local current_item = cursor.check_stack(cursor_stack, player.cursor_ghost, player_table.ghost_item)

  if current_item then
    local item_data = player_local_data[list_index][current_item]
    if item_data then
      local item_name = item_data[direction]
      if item_name then
        local spawn_item = player_table.settings.spawn_items_when_cheating and (player.cheat_mode or (player.controller_type == defines.controllers.editor))
        local main_inventory = player_table.main_inventory
        local item_count = main_inventory.get_item_count(item_name)
        if item_count > 0 then
          player.clean_cursor()
          cursor_stack.set_stack{name=item_name, count=main_inventory.remove{name=item_name, count=game.item_prototypes[item_name].stack_size}}
          return
        elseif spawn_item then
          player.clean_cursor()
          cursor_stack.set_stack{name=item_name, count=game.item_prototypes[item_name].stack_size}
          return
        else
          player.clean_cursor()
          player_table.ghost_item = item_name
          player.cursor_ghost = game.item_prototypes[item_name].place_result.name
        end
      end
    end
  end
end

function cursor.scroll_history(player_index)

end

return cursor