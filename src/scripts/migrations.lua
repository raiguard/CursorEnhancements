return {
  ["1.1.0"] = function()
    -- add `proxies` table
    global.proxies = {
      by_proxy = {},
      by_target = {}
    }

    -- add `building` flag to player tables
    for _, player_table in pairs(global.players) do
      player_table.flags.building = false
    end
  end
}