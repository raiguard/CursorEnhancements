local local_data = {}

-- local util = require("__core__.lualib.util")

local function generate_internal(player_index, player_table)
  local_data[player_index] = {}

  for type, group in pairs(player_table.item_sets) do
    local output = {}
    for _, set in ipairs(group) do
      -- iterate over set until we reach the end
      local previous
      local current = set[1]
      local next = set[2]
      local i = 1
      while current do
        output[current] = {
          previous = previous,
          next = next
        }
        i = i + 1
        previous = current
        current = set[i]
        next = set[i + 1]
      end
      local_data[player_index][type] = output
    end
  end
end

function local_data.generate(player_index)
  if player_index then
    generate_internal(player_index, global.players[player_index])
  else
    for i, player_table in pairs(global.players) do
      generate_internal(i, player_table)
    end
  end
end

return local_data