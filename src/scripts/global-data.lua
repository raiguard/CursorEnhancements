local global_data = {}

function global_data.init()
  global.players = {}

  global_data.build_default_registry()
end

-- build the default upgrade/downgrade registry
function global_data.build_default_registry()
  local prototypes = game.entity_prototypes
  local data = {}
  for name,prototype in pairs(prototypes) do
    if prototype.next_upgrade and prototype.items_to_place_this then
      local upgrade = prototype.next_upgrade.name
      for _,item in ipairs(prototype.items_to_place_this) do
        if not data[item.name] then data[item.name] = {} end
        data[item.name].upgrade = upgrade
      end
      for _,item in ipairs(prototypes[upgrade].items_to_place_this) do
        if not data[item.name] then data[item.name] = {} end
        data[item.name].downgrade = name
      end
    end
  end
  global.default_registry = data
end

return global_data