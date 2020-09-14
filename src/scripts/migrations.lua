return {
  ["1.1.0"] = function()
    -- add `proxies` table
    global.proxies = {
      by_proxy = {},
      by_target = {}
    }

    -- add `building` flag, remove other flags (no longer needed)
    for _, player_table in pairs(global.players) do
      player_table.flags.building = false
      player_table.flags.gui_open = nil
      player_table.flags.holding_item = nil
    end
  end
}