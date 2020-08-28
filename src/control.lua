local event = require("__flib__.event")
local migration = require("__flib__.migration")

local constants = require("constants")

local api = require("scripts.api")
local cursor = require("scripts.cursor")
local global_data = require("scripts.global-data")
local local_data = require("scripts.local-data")
local migrations = require("scripts.migrations")
local player_data = require("scripts.player-data")

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS

-- BOOTSTRAP

event.on_init(function()
  global_data.init()
  for i, player in pairs(game.players) do
    player_data.init(i)
    local player_table = global.players[i]
    player_data.refresh(player, player_table)
    local_data.generate(i)
  end
end)

event.on_load(function()
  local_data.generate()
end)

event.on_configuration_changed(function(e)
  migration.on_config_changed(e, migrations)
end)

-- GUI

event.on_gui_opened(function(e)
  global.players[e.player_index].flags.gui_open = true
end)

event.on_gui_closed(function(e)
  global.players[e.player_index].flags.gui_open = false
end)

-- INPUTS

event.register(constants.item_scroll_input_names, function(e)
  local _, _, scroll_type, direction = string.find(e.input_name, "^cen-%-scroll%-(%a*)%-(%w*)$")
  local data = local_data
  cursor.scroll(e.player_index, scroll_type, direction)
end)

event.register("cen-recall-last-item", function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  if player_table.last_item and not cursor.set_stack(player, player.cursor_stack, player_table, player_table.last_item) then
    player.print{"cen-message.unable-to-recall"}
  end
end)

-- PLAYER

event.on_player_created(function(e)
  player_data.init(e.player_index)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  player_data.refresh(player, player_table)
  local_data.generate(e.player_index)
end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)

event.on_player_cursor_stack_changed(function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  local cursor_stack = player.cursor_stack
  local current_item = cursor_stack and cursor_stack.valid_for_read and cursor_stack.name

  if current_item then
    player_table.last_item = current_item
  elseif
    player_table.settings.ghost_cursor_transitions
    and not player_table.flags.gui_open
    and not player.cursor_ghost
  then
    local last_item = player_table.last_item
    if last_item then
      player_data.ensure_valid_inventory(player, player_table)
      if player_table.main_inventory.get_item_count(last_item) == 0 then
        local entity = game.item_prototypes[last_item].place_result
        if entity then
          cursor.set_stack(player, cursor_stack, player_table, last_item)
        end
      end
    end
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
  if string.sub(e.setting, 1, 3) == "cen-" and e.setting_type == "runtime-per-user" then
    player_data.update_settings(game.get_player(e.player_index), global.players[e.player_index])
  end
end)

-- -----------------------------------------------------------------------------
-- INTERFACE

remote.add_interface("CursorEnhancements", api)