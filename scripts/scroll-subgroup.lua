local table = require("__flib__/table")

local util = require("__CursorEnhancements__/scripts/util")

--- @type table<string, string[]>
local subgroups = {}
for subgroup_name in pairs(prototypes.item_subgroup) do
  local subgroup = {}
  local prototypes = prototypes.get_item_filtered({ { filter = "subgroup", subgroup = subgroup_name } })
  for name, item in pairs(prototypes) do
    if name ~= "dummy-steel-axe" and not item.has_flag("spawnable") and not item.hidden then
      subgroup[#subgroup + 1] = name
    end
  end
  subgroups[subgroup_name] = subgroup
end

--- @param e EventData.CustomInputEvent
--- @param delta integer
local function scroll_item(e, delta)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  local item = util.get_cursor_item(player)
  if not item then
    return
  end
  local subgroup_name = prototypes.item[item].subgroup.name
  if not subgroup_name then
    return
  end
  local subgroup = subgroups[subgroup_name]
  local index = table.find(subgroup, item)
  if not index then
    return
  end
  local new_item = subgroup[index + delta]
  if not new_item then
    return
  end
  if util.set_cursor(player, new_item) then
    player.create_local_flying_text({ text = prototypes.item[new_item].localised_name, create_at_cursor = true })
  end
end

local scroll_subgroup = {}

scroll_subgroup.events = {
  --- @param e EventData.CustomInputEvent
  ["cen-scroll-next"] = function(e)
    scroll_item(e, 1)
  end,
  --- @param e EventData.CustomInputEvent
  ["cen-scroll-previous"] = function(e)
    scroll_item(e, -1)
  end,
}

return scroll_subgroup
