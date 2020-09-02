local util = {}

function util.apply_overrides(data, overrides, item_prototypes)
  for name, upgrade in pairs(overrides) do
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

return util