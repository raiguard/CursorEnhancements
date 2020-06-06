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
  for i, player in pairs(game.players) do

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

-- PLAYER

event.on_player_created(function(e)
  player_data.init(e.player_index)
end)

event.on_player_joined_game(function(e)

end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)