local util = require("scripts.util")

local max_history_size = 10

--- @param e EventData.CustomInputEvent
local function on_recall_last_item(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end

  local history = storage.item_history[e.player_index]
  local index = storage.history_index[e.player_index]

  if not (history and index) then
    return
  end

  local cursor_item = util.get_cursor_item(player)
  if cursor_item and index <= 1 then
    index = index + 1
  end

  local item = history[index]
  if not item then
    return
  end

  util.set_cursor(player, item)

  if index + 1 > #history then
    storage.history_index[e.player_index] = 0
  else
    storage.history_index[e.player_index] = index + 1
  end

  storage.item_update_tick[e.player_index] = e.tick
end

--- @param e EventData.on_player_cursor_stack_changed
local function on_player_cursor_stack_changed(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end

  if e.tick == storage.item_update_tick[e.player_index] then
    return
  end

  local history = storage.item_history[e.player_index]
  if not history then
    history = {}
    storage.item_history[e.player_index] = history
  end

  storage.history_index[e.player_index] = 1

  local cursor_item = util.get_cursor_item(player)
  if not cursor_item or cursor_item.name.has_flag("spawnable") then
    return
  end

  for i, history_item in pairs(history) do
    if serpent.line(cursor_item) == serpent.line(history_item) then
      table.insert(history, 1, table.remove(history, i))
      return
    end
  end

  table.insert(history, 1, cursor_item)

  if #history > max_history_size then
    table.remove(history)
  end
end

local recall_last_item = {}

recall_last_item.on_init = function()
  --- @type table<uint, table<number, ItemWithQualityID?>>
  storage.item_history = {}
  --- @type table<uint, number>
  storage.item_update_tick = {}
  --- @type table<uint, number>
  storage.history_index = {}
end

recall_last_item.events = {
  ["cen-recall-last-item"] = on_recall_last_item,
  [defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed,
}

return recall_last_item
