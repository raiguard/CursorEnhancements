local local_data = {
  groups = {},
  relatives = {}
}

local mappings = {
  base = require("scripts.mappings.base")
}

function local_data.generate()
  for mapping_name, mapping in pairs(mappings.base) do
    local i = 0
    for i = 1, #mapping do
      local group = mapping[i]

      -- groups


      -- relatives
      local relatives = local_data.relatives
      local previous_relative
      local current_relative = group[1]
      local k = 1
      while current_relative do
        local_data.relatives[current_relative] = {
          previous = previous_relative and previous_relative.item,
        }
        k = k + 1
        previous_relative = current_relative
        current_relative = group[k]
      end
    end
  end
end

return local_data