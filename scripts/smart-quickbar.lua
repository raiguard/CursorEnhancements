local util = require("__CursorEnhancements__/scripts/util")

--- @param e EventData.on_player_cursor_stack_changed
local function on_player_cursor_stack_changed(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  local item = util.get_cursor_item(player)
  if not item then
    return
  end

  for i = 1, 100 do
    local slot = player.get_quick_bar_slot(i)
    if slot and slot.name == item then
      player.set_active_quick_bar_page(1, math.floor(i / 10) + 1)
    end
  end
end

--- @param e EventData.CustomInputEvent
local function on_smart_pipette(e)
  global.pipetting[e.player_index] = true
end

local function init()
  --- @type table<uint, boolean>
  global.pipetting = {}
end

local smart_quickbar = {}

smart_quickbar.on_init = init
smart_quickbar.on_configuration_changed = init

smart_quickbar.events = {
  ["cen-linked-smart-pipette"] = on_smart_pipette,
  [defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed,
}

return smart_quickbar
