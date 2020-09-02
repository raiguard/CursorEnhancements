local global_data = {}

local constants = require("constants")

function global_data.init()
  global.players = {}
end

-- added to from scripts.remote-interface
global_data.mod_overrides = {}

local function apply_overrides(data, overrides, item_prototypes)
  for i = 1, #overrides do
    local override = overrides[i]
    local name = override[1]
    local upgrade = override[2]

    if item_prototypes[name] and item_prototypes[upgrade] then
      -- this entity
      local entity_data = data[name]
      if entity_data then
        entity_data.upgrade = upgrade
      else
        data[name] = {upgrade=upgrade}
      end
      -- upgrade's downgrade
      local upgrade_data = data[upgrade]
      if upgrade_data then
        upgrade_data.downgrade = name
      else
        data[upgrade] = {downgrade=name}
      end
    end
  end
end

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
      apply_overrides(data, overrides, item_prototypes)
    end
  end
  -- mod overrides
  apply_overrides(data, global_data.mod_overrides, item_prototypes)

  global.default_registry = data
end

return global_data