local util = require('scripts.util')

local belts = {}

function belts.get_belts_by_speed(is_cheat)
  local belts_by_speed = {}

  local filters = {
    { filter = "transport-belt-connectable" },
    { filter = "buildable", mode = "and"}
  }

  if not is_cheat then
    table.insert(filters, { filter = "type", type = "loader", invert = true, mode = "and" })
  end

  local belt_entites = game.get_filtered_entity_prototypes(filters)

  for _, prototype in pairs(belt_entites) do
    local current_items = prototype.items_to_place_this
    if current_items then
      local current_item = current_items[1].name
      local current_speed = prototype.belt_speed

      belts_by_speed[current_speed] = belts_by_speed[current_speed] or {}
      table.insert(belts_by_speed[current_speed], current_item)
    end
  end

  return belts_by_speed
end

function belts.compute_registry(belt_scroll_type, upgrade_table, is_cheat)
  local belts_by_speed = belts.get_belts_by_speed(is_cheat)
  local registry = {
    next = {},
    previous = {}
  }

  if belt_scroll_type == "levels" then
    -- Easy case, just return nothing since this is already handled
  elseif belt_scroll_type == "types" then
    -- Compute upgrades for all belts of a certain speed only

    local upgrade_groups = {}
    for speed, entries in pairs(belts_by_speed) do
      table.insert(upgrade_groups, util.order_items(entries))
    end

    registry = util.upgrade_groups_to_registry(upgrade_groups)

  elseif belt_scroll_type == "levels-then-types" then
    -- Starting from the lowest speed, run through next_upgrade
    -- and then move on to the next speed and repeat.

    local upgrade_groups = {}
    local sorted_speeds = util.sort_keys(belts_by_speed)

    local seen = {}
    for _, speed in ipairs(sorted_speeds) do
      local upgrades = {}
      local sorted_entries = util.order_items(belts_by_speed[speed])
      for __, entry in ipairs(sorted_entries) do

        local current = entry
        while current do
          if not seen[current] then
            table.insert(upgrades, current)
            seen[current] = true
          end
          current = upgrade_table[current]
        end
      end
      table.insert(upgrade_groups, upgrades)
    end

    registry = util.upgrade_groups_to_registry(upgrade_groups)

  elseif belt_scroll_type == "types-then-levels" then
    -- starting from the lowest speed, run through that speed
    -- then move on to the next speed and repeat
    local upgrades = {}

    local sorted_speeds = util.sort_keys(belts_by_speed)
    for _, speed in ipairs(sorted_speeds) do
      local sorted_entries = util.order_items(belts_by_speed[speed])
      for __, entry in ipairs(sorted_entries) do
        table.insert(upgrades, entry)
      end
    end

    registry = util.upgrade_groups_to_registry({ upgrades })
  else
    error("Unknown belt type " .. belt_scroll_type)
  end
  
  return registry
end

return belts
