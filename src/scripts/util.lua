local util = {}

-- TODO rename "upgrade" and "downgrade" to "next" and "previous"
function util.apply_overrides(data, overrides, item_prototypes)
  for name, upgrade in pairs(overrides) do
    if item_prototypes[name] and (upgrade and item_prototypes[upgrade] or true) then
      local old_upgrade
      -- this entity
      local entity_data = data[name]
      if entity_data then
        old_upgrade = entity_data.upgrade
        if upgrade then
          entity_data.upgrade = upgrade
        else
          entity_data.upgrade = nil
          if not entity_data.downgrade then
            data[name] = nil
          end
        end
      elseif upgrade then
        data[name] = {upgrade=upgrade}
      end
      -- old upgrade's downgrade
      if old_upgrade then
        local old_upgrade_data = data[old_upgrade]
        if old_upgrade_data then
          old_upgrade_data.downgrade = nil
          if not old_upgrade_data.upgrade then
            data[old_upgrade] = nil
          end
        end
      end
      -- new upgrade's downgrade
      if upgrade then
        local upgrade_data = data[upgrade]
        if upgrade_data then
          upgrade_data.downgrade = name
        elseif upgrade then
          data[upgrade] = {downgrade=name}
        end
      end
    end
  end
end

return util