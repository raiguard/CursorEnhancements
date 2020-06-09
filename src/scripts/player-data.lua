local player_data = {}

local constants = require("constants")

function player_data.init(player_index)
  local player = game.get_player(player_index)
  global.players[player_index] = {
    flags = {
      config_gui_open = false,
      gui_open = false,
      holding_item = false
    },
    gui = nil,
    item_sets = {
      --! HARDCODED DEFAULTS FOR NOW
      [1] = {
        {"transport-belt", "fast-transport-belt", "express-transport-belt"},
        {"underground-belt", "fast-underground-belt", "express-underground-belt"},
        {"splitter", "fast-splitter", "express-splitter"},
        {"loader", "fast-loader", "express-loader"}
      },
      [2] = {
        {"transport-belt", "underground-belt", "splitter", "loader"},
        {"fast-transport-belt", "fast-underground-belt", "fast-splitter", "fast-loader"},
        {"express-transport-belt", "express-underground-belt", "express-splitter", "express-loader"}
      }
    },
    last_item = nil,
    main_inventory = player.get_main_inventory(),
    settings = {}
  }
end

function player_data.update_settings(player, player_table)
  local player_settings = player.mod_settings
  local saved_settings = player_table.settings
  for setting_name, save_as in pairs(constants.setting_name_mapping) do
    saved_settings[save_as] = player_settings[setting_name].value
  end
end

function player_data.refresh(player, player_table)
  player_data.update_settings(player, player_table)
end

function player_data.ensure_valid_inventory(player, player_table)
  if not player_table.main_inventory.valid then
    player_table.main_inventory = player.get_main_inventory()
  end
end

return player_data