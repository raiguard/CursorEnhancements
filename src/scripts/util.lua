local util = {}

function util.apply_overrides(registry, overrides, item_prototypes)
  for item, next_item in pairs(overrides) do
    if next_item then
      if item_prototypes[item] and item_prototypes[next_item] then
        local stored_next_item = registry.next[item]
        if stored_next_item then
          registry.previous[stored_next_item] = nil
        end
        registry.next[item] = next_item
        registry.previous[next_item] = item
      end
    elseif item_prototypes[item] then
      local next_item_name = registry.next[item]
      if next_item_name then
        registry.previous[next_item_name] = nil
      end
      registry.next[item] = nil
    end
  end
end

function util.sort_keys(keys)
  local sorted_keys = {}
  for k in pairs(keys) do table.insert(sorted_keys, k) end
  table.sort(sorted_keys)

  return sorted_keys
end

function util.order_items(item_names)
  local function comparator(a, b)
    return game.item_prototypes[a].order < game.item_prototypes[b].order
  end
  table.sort(item_names, comparator)
  return item_names
end

-- Takes an array of upgrade arrays and converts them into
-- a registry structure. Input looks like:
--
-- { { 'transport-belt', 'express-transport-belt' }, { 'splitter', 'express-splitter' } }
function util.upgrade_groups_to_registry(upgrade_groups)
  local registry = {
    next = {},
    previous = {}
  }

  for _, upgrade_group in pairs(upgrade_groups) do
    local previous = nil
    for __, entry in ipairs(upgrade_group) do
      if previous ~= nil then
        registry.next[previous] = entry
        registry.previous[entry] = previous
      end
      previous = entry
    end
  end

  return registry
end

return util
