return {
  ["1.0.2"] = function()
    -- add `building` flag, remove other flags (no longer needed)
    for _, player_table in pairs(global.players) do
      player_table.flags.building = false
      player_table.flags.gui_open = nil
      player_table.flags.holding_item = nil
    end
  end,
  ["1.1.3"] = function()
    for _, player_table in pairs(global.players) do
      player_table.flags = nil
      player_table.last_build_tick = 0
    end
  end,
}
