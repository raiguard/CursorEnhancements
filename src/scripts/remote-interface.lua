-- see https://github.com/raiguard/Factorio-CursorEnhancements/wiki/Remote-Interface-Documentation

local remote_interface = {}

local global_data = require("scripts.global-data")

function remote_interface.add_overrides(mod_overrides)
  for name, upgrade in pairs(mod_overrides) do
    global_data.mod_overrides[name] = upgrade
  end
end

return remote_interface