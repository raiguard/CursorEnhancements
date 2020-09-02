local remote_interface = {}

local global_data = require("scripts.global-data")

function remote_interface.add_overrides(mod_overrides)
  for i = 1, #mod_overrides do
    global_data.mod_overrides[#global_data.mod_overrides+1] = mod_overrides[i]
  end
end

return remote_interface