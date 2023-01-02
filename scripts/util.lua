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

return util
