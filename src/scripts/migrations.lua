return {
  ["1.1.0"] = function()
    -- add `proxies` table
    global.proxies = {
      by_proxy = {},
      by_target = {}
    }

    -- add `building` flag and remove `holding_item` flag
    for _, player_table in pairs(global.players) do
      player_table.flags.building = false
      player_table.flags.holding_item = nil
    end
  end
}