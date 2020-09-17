local global_data = {}

local constants = require("constants")

local util = require("scripts.util")

function global_data.init()
  global.players = {}

  global_data.build_global_registry()
end

-- build the default upgrade/downgrade registry
function global_data.build_global_registry()
  local entity_prototypes = game.entity_prototypes
  local item_prototypes = game.item_prototypes
  local registry = {
    next = {},
    previous = {}
  }

  -- auto-generated
  for _, prototype in pairs(entity_prototypes) do
    local next_entity = prototype.next_upgrade
    local current_items = prototype.items_to_place_this
    if next_entity and current_items then
      local next_items = next_entity.items_to_place_this
      if next_items then
        -- TODO handle multiple items and both ends
        -- this is a temporary solution
        local current_item = current_items[1].name
        local next_item = next_items[1].name
        registry.next[current_item] = next_item
        registry.previous[next_item] = current_item
      end
    end
  end

  -- default overrides
  for mod_name, overrides in pairs(constants.default_overrides) do
    if script.active_mods[mod_name] then
      util.apply_overrides(registry, overrides, item_prototypes)
    end
  end

  global.registry = registry
end

return global_data