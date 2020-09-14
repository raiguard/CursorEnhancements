local cursor = {}

local event = require("__flib__.event")

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
  local is_cheating = player.cheat_mode or (player.controller_type == defines.controllers.editor)
  local spawn_item = player_table.settings.spawn_items_when_cheating

  -- space exploration - don't spawn items when in the satellite view
  if script.active_mods["space-exploration"] and player.controller_type == defines.controllers.god then
    spawn_item = false
  end

  -- main inventory
  player_data.ensure_valid_inventory(player, player_table)
  local main_inventory = player_table.main_inventory

  -- set cursor stack
  local item_stack, item_stack_index = main_inventory.find_item_stack(item_name)
  if item_stack and item_stack.valid then
    if player.clean_cursor() then
      -- actually transfer from the main inventory, then set the hand location
      cursor_stack.transfer_stack(item_stack)
      player.hand_location = {inventory=main_inventory.index, slot=item_stack_index}
    end
    return true
  elseif spawn_item and is_cheating then
    local stack_spec = {name=item_name, count=game.item_prototypes[item_name].stack_size}
    -- insert into main inventory first, then transfer and set the hand location
    if main_inventory.can_insert(stack_spec) and player.clean_cursor() then
      main_inventory.insert(stack_spec)
      local new_stack, new_stack_index = main_inventory.find_item_stack(item_name)
      cursor_stack.transfer_stack(new_stack)
      player.hand_location = {inventory=main_inventory.index, slot=new_stack_index}
    else
      player.print{"cen-message.main-inventory-full"}
    end
    return true
  elseif player.clean_cursor() then
    player_table.last_item = item_name
    player.cursor_ghost = item_name
    return true
  end
end

function cursor.scroll(player_index, direction)
  local player = game.get_player(player_index)
  local player_table = global.players[player_index]
  local cursor_stack = player.cursor_stack
  local current_item = cursor.check_stack(cursor_stack, player.cursor_ghost)

  if current_item then
    -- check personal registry, then the global registry
    local registry = player_table.registry[current_item]
    if not registry or not registry[direction] then
      registry = global.registry[current_item]
    end
    -- set stack
    if registry and registry[direction] then
      cursor.set_stack(player, cursor_stack, player_table, registry[direction])
    end
  end
end

function cursor.create_proxy(player, selected, item)
  -- pass through request proxy
  if selected.type == "item-request-proxy" then
    selected = selected.proxy_target
    if not selected then return end
  end
  -- item info
  local prototype = game.item_prototypes[item]
  local item_name = prototype.localised_name
  local stack_size = prototype.stack_size
  -- flying text content
  local text
  -- proxy
  local proxy = global.proxies.by_target[selected.unit_number]

  -- create / don't create proxy
  if selected.can_insert{name=item} then
    if proxy then
      -- update proxy's request count
      local requests = proxy.item_requests
      local request_count = stack_size + (requests[item] or 0)
      proxy.item_requests = {table.unpack(requests), [item]=request_count}
      -- flying text
      text = {"cen-message.updated-request-count", request_count, item_name}
    else
      -- create the proxy
      proxy = selected.surface.create_entity{
        name = "item-request-proxy",
        position = selected.position,
        force = selected.force,
        target = selected,
        modules = {[item]=stack_size}
      }
      -- store global references
      global.proxies.by_target[selected.unit_number] = proxy
      global.proxies.by_proxy[proxy.unit_number] = selected.unit_number
      -- register to on_entity_destroyed
      event.register_on_entity_destroyed(proxy)
      -- flying text
      text = {"cen-message.requesting-from-network", stack_size, item_name}
    end
  else
    -- flying text
    text = {"cen-message.cannot-request", item_name}
    -- play sound
    player.play_sound{path="utility/cannot_build"}
  end
  -- create flying text
  player.create_local_flying_text{
    text = text,
    position = selected.position,
  }
end

return cursor