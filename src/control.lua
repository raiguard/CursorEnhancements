local event = require("__flib__.event")
local migration = require("__flib__.migration")

local constants = require("constants")

local cursor = require("scripts.cursor")
local global_data = require("scripts.global-data")
local migrations = require("scripts.migrations")
local player_data = require("scripts.player-data")
local remote_interface = require("scripts.remote-interface")

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS

-- BOOTSTRAP

event.on_init(function()
  global_data.init()
  for i, player in pairs(game.players) do
    player_data.init(i, player)
    player_data.refresh(player, global.players[i])
  end
end)

event.on_configuration_changed(function(e)
  if migration.on_config_changed(e, migrations) then
    global_data.build_global_registry()
    for i, player in pairs(game.players) do
      player_data.refresh(player, global.players[i])
    end
  end
end)

-- INPUTS

event.register(constants.item_scroll_input_names, function(e)
  local _, _, direction = string.find(e.input_name, "^cen-%-scroll%-(%a*)$")
  cursor.scroll(e.player_index, direction)
end)

event.register("cen-recall-last-item", function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  if player_table.last_item
    and not cursor.set_stack(player, player.cursor_stack, player_table, player_table.last_item)
  then
    player.print{"cen-message.unable-to-recall"}
  end
end)

event.register("cen-smart-pipette", function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  if player_table.settings.tile_pipette then
    local cursor_stack = player.cursor_stack
    if cursor_stack and not cursor_stack.valid_for_read and not player.cursor_ghost and not player.selected then
      local cursor_position = e.cursor_position
      local tile_area = {
        left_top = {x = math.floor(cursor_position.x), y = math.floor(cursor_position.y)},
        right_bottom = {x = math.ceil(cursor_position.x), y = math.ceil(cursor_position.y)},
      }
      local tile = player.surface.find_tiles_filtered{area = tile_area}[1]
      if tile and tile.valid then
        local items_to_place_this = tile.prototype.items_to_place_this
        if items_to_place_this then
          local item = items_to_place_this[1]
          if item then
            cursor.set_stack(player, cursor_stack, global.players[e.player_index], item.name)
            player.play_sound{
              path = "utility/smart_pipette"
            }
          end
        end
      end
    end
  end
end)

-- PLAYER

event.on_player_created(function(e)
  local player = game.get_player(e.player_index)
  player_data.init(e.player_index, player)
  local player_table = global.players[e.player_index]
  player_data.refresh(player, player_table)
end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)

event.register({defines.events.on_player_built_tile, defines.events.on_pre_build}, function(e)
  global.players[e.player_index].last_build_tick = game.ticks_played
end)

event.on_player_cursor_stack_changed(function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]

  local cursor_stack = player.cursor_stack
  local current_item = cursor.check_stack(cursor_stack, player.cursor_ghost)

  if current_item then
    player_table.last_item = current_item
  elseif
    player_table.last_item
    and not constants.blacklisted_item_types[game.item_prototypes[player_table.last_item].type]
    and player_table.last_build_tick == game.ticks_played
    and player_table.settings.ghost_cursor_transitions
  then
    cursor.set_stack(player, cursor_stack, player_table, player_table.last_item)
  end
end)

event.on_player_main_inventory_changed(function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]

  if player_table.settings.ghost_cursor_transitions then
    local cursor_ghost = player.cursor_ghost
    if cursor_ghost then
      player_data.ensure_valid_inventory(player, player_table)
      local main_inventory = player_table.main_inventory
      if main_inventory.get_item_count(cursor_ghost.name) > 0 then
        cursor.set_stack(player, player.cursor_stack, player_table, cursor_ghost.name)
      end
    end
  end
end)

-- SETTINGS

event.on_runtime_mod_setting_changed(function(e)
  if string.sub(e.setting, 1, 4) == "cen-" and e.setting_type == "runtime-per-user" then
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    player_data.update_settings(player, player_table)
    if e.setting == "cen-personal-registry-overrides" then
      player_data.update_personal_overrides(player, player_table)
    end
  end
end)

-- -----------------------------------------------------------------------------
-- REMOTE INTERFACE

remote.add_interface("CursorEnhancements", remote_interface)
