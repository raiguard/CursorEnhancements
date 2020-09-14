local player_data = {}

local table = require("__flib__.table")

local constants = require("constants")

local util = require("scripts.util")

function player_data.init(player_index, player)
  global.players[player_index] = {
    flags = {
      building = false,
      gui_open = false,
      holding_item = false
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

function player_data.update_personal_overrides(player, player_table)
  -- retrieve and parse personal overrides
  local overrides = game.json_to_table(player.mod_settings['cen-personal-registry-overrides'].value)
  if not overrides or type(overrides) == "string" then
    player.print{'cen-message.invalid-personal-overrides-format'}
    overrides = {}
  end
  -- convert to registry and save
  player_table.registry = util.apply_overrides({}, overrides, game.item_prototypes)
end

function player_data.refresh(player, player_table)
  player_data.update_settings(player, player_table)
  player_data.update_personal_overrides(player, player_table)
end

function player_data.ensure_valid_inventory(player, player_table)
  if not player_table.main_inventory or not player_table.main_inventory.valid then
    player_table.main_inventory = player.get_main_inventory()
  end
end

return player_data