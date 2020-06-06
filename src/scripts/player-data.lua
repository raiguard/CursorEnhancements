local player_data = {}

function player_data.init(player_index)
  global.players[player_index] = {
    gui = {},
    history = {}
  }
end

return player_data