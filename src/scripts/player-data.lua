local player_data = {}

local table = require("__flib__.table")

local constants = require("constants")

function player_data.init(player_index, player)
  global.players[player_index] = {
    flags = {
      config_gui_open = false,
      gui_open = false,
      holding_item = false
    },
    gui = nil,
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
  -- player_data.build_personal_registry(player, player_table)
end

function player_data.ensure_valid_inventory(player, player_table)
  if not player_table.main_inventory.valid then
    player_table.main_inventory = player.get_main_inventory()
  end
end

function player_data.build_personal_registry(player, player_table)
  local prototypes = game.entity_prototypes
  local data = table.deep_copy(global.default_registry)
  local registry = game.json_to_table(player.mod_settings['cen-custom-upgrade-registry'].value)
  if not registry or type(registry) == "string" then
    player.print{'cen-message.invalid-string'}
    return data
  end
  for name,upgrade in pairs(registry) do
    -- get objects and validate them, or error if not
    local prototype = prototypes[name]
    if not prototype then
      player.print{'cen-message.invalid-name', name}
      goto continue
    end
    local upgrade_prototype = prototypes[upgrade]
    if not upgrade_prototype then
      player.print{'cen-message.invalid-upgrade-name', upgrade}
      goto continue
    end
    for _,item in ipairs(prototype.items_to_place_this or {}) do
      if not data[item.name] then data[item.name] = {} end
      data[item.name].upgrade = upgrade
    end
    for _,item in ipairs(upgrade_prototype.items_to_place_this or {}) do
      if not data[item.name] then data[item.name] = {} end
      data[item.name].downgrade = name
    end
    ::continue::
  end
  player_table.registry = registry
end

return player_data