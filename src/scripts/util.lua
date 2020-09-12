local util = {}

function util.apply_overrides(data, overrides, item_prototypes)
  for item, next_item in pairs(overrides) do
    if item_prototypes[item] and (next_item and item_prototypes[next_item] or true) then
      local old_next_item
      -- this entity
      local item_data = data[item]
      if item_data then
        old_next_item = item_data.next
        if next_item then
          item_data.next = next_item
        else
          item_data.next = nil
          if not item_data.previous then
            data[item] = nil
          end
        end
      elseif next_item then
        data[item] = {next=next_item}
      end
      -- old next's previous
      if old_next_item then
        local old_next_data = data[old_next_item]
        if old_next_data then
          old_next_data.previous = nil
          if not old_next_data.next then
            data[old_next_item] = nil
          end
        end
      end
      -- new next's previous
      if next_item then
        local next_item_data = data[next_item]
        if next_item_data then
          next_item_data.previous = item
        elseif next_item then
          data[next_item] = {previous=item}
        end
      end
    end
  end

  return data
end

return util