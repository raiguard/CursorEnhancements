local event = require("__flib__.event")
local gui = require("__flib__.gui")
local migration = require("__flib__.migration")

local constants = require("constants")

local cursor = require("scripts.cursor")
local global_data = require("scripts.global-data")
local local_data = require("scripts.local-data")
local player_data = require("scripts.player-data")

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS

-- BOOTSTRAP

event.on_init(function()
  gui.init()

  global_data.init()
  for i, player in pairs(game.players) do
    player_data.init(i)
    player_data.refresh(player, global.players[i])
  end
  local_data.generate()

  gui.build_lookup_tables()
end)

event.on_load(function()
  local_data.generate()

  gui.build_lookup_tables()
end)

event.on_configuration_changed(function(e)
  if migration.on_config_changed(e, {}) then

  else

  end
end)

-- GUI

gui.register_handlers()

-- INPUTS

event.register(constants.item_scroll_input_names, function(e)
  local _, _, list_index, direction = string.find(e.input_name, "^ct%-scroll%-items%-(%d)%-(%w*)$")
  cursor.scroll_items(e.player_index, tonumber(list_index), direction)
end)

event.register({"ct-scroll-history-next", "ct-scroll-history-previous"}, function(e)
  cursor.scroll_history(e.player_index)
end)

-- PLAYER

event.on_player_created(function(e)
  player_data.init(e.player_index)
  player_data.refresh(game.get_player(e.player_index), global.players[e.player_index])
  local_data.generate(e.player_index)
end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)

event.on_player_pipette(function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  local cursor_ghost = player.cursor_ghost

  if cursor_ghost then
    local possible_items = game.entity_prototypes[cursor_ghost.name].items_to_place_this
    if possible_items then
      player_table.ghost_item = possible_items[1].name
    end
  end
end)

event.on_player_cursor_stack_changed(function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  local cursor_stack = player.cursor_stack
  local current_item = cursor_stack and cursor_stack.valid_for_read and cursor_stack.name
  local ghost_item = player_table.ghost_item

  if current_item and ghost_item and current_item ~= ghost_item then
    player_table.ghost_item = nil
  end
end)