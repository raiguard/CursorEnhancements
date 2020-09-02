local global_data = {}

local constants = require("constants")

local util = require("scripts.util")

function global_data.init()
  global.players = {}
end

-- added to from scripts.remote-interface
global_data.mod_overrides = {}

-- build the default upgrade/downgrade registry
function global_data.build_global_registry()
  local entity_prototypes = game.entity_prototypes
  local item_prototypes = game.item_prototypes
  local data = {}
  -- auto-generated
  for name, prototype in pairs(entity_prototypes) do
    if prototype.next_upgrade and prototype.items_to_place_this then
      local upgrade = prototype.next_upgrade.name
      for _,item in ipairs(prototype.items_to_place_this) do
        if not data[item.name] then data[item.name] = {} end
        data[item.name].upgrade = upgrade
      end
      for _,item in ipairs(entity_prototypes[upgrade].items_to_place_this) do
        if not data[item.name] then data[item.name] = {} end
        data[item.name].downgrade = name
      end
    end
  end
  -- default overrides
  for mod_name, overrides in pairs(constants.default_overrides) do
    if script.active_mods[mod_name] then
      util.apply_overrides(data, overrides, item_prototypes)
    end
  end
  -- mod overrides
  util.apply_overrides(data, global_data.mod_overrides, item_prototypes)

  global.registry = data
end

return global_data