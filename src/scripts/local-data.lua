local local_data = {}

-- local util = require("__core__.lualib.util")

local function generate_internal(player_index, player_table)
  local_data[player_index] = {}

  for i = 1, 2 do
    local output = {}
    local parent_set = player_table.item_sets[i]

    for _, set in ipairs(parent_set) do
      -- iterate over set until we reach the end
      local previous
      local current = set[1]
      local next = set[2]
      local j = 1
      while current do
        output[current] = {
          previous = previous,
          next = next
        }
        j = j + 1
        previous = current
        current = set[j]
        next = set[j + 1]
      end
    end

    local_data[player_index][i] = output
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