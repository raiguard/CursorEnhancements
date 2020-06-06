local event = require("__flib__.event")
local gui = require("__flib__.gui")
local migration = require("__flib__.migration")

local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS

-- BOOTSTRAP

event.on_init(function()
  gui.init()

  global_data.init()
  for i in pairs(game.players) do
    player_data.init(i)
  end

  gui.build_lookup_tables()
end)

event.on_load(function()
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

event.register({"ct-scroll-items-1-up", "ct-scroll-items-1-down"}, function(e)
  __DebugAdapter.print(e)
end)

event.register({"ct-scroll-items-2-up", "ct-scroll-items-2-down"}, function(e)
  __DebugAdapter.print(e)
end)

event.register({"ct-scroll-history-up", "ct-scroll-history-down"}, function(e)
  __DebugAdapter.print(e)
end)

-- PLAYER

event.on_player_created(function(e)
  player_data.init(e.player_index)
end)

event.on_player_joined_game(function(e)

end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)