-- see https://github.com/raiguard/Factorio-CursorEnhancements/wiki/Remote-Interface-Documentation

local remote_interface = {}

local constants = require("constants")
local util = require("scripts.util")

function remote_interface.add_overrides(mod_overrides)
	util.apply_overrides(global.registry, mod_overrides, game.item_prototypes)
end

function remote_interface.version()
	return constants.interface_version
end

return remote_interface
