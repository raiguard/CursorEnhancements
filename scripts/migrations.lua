local migration = require("__flib__.migration")

local migrations = {
  ["2.0.0"] = function()
    storage.built_item = {}
    storage.last_item = {}
  end,
  ["2.2.0"] = function()
    storage.subgroups = nil
  end,
  ["2.2.2"] = function()
    storage.item_history = {}
    storage.item_update_tick = {}
    storage.history_index = {}
    storage.last_item = nil
  end,
}

local function on_configuration_changed(e)
  migration.on_config_changed(e, migrations)
end

return {
  on_configuration_changed = on_configuration_changed,
}
