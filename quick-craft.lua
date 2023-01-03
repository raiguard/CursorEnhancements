local util = require("__CursorEnhancements__/util")

local crafting_controllers = {
	[defines.controllers.character] = true,
	[defines.controllers.god] = true,
}

--- @param e EventData.CustomInputEvent
local function on_quick_craft(e)
	local player = game.get_player(e.player_index)
	if not player then
		return
	end

	if not crafting_controllers[player.controller_type] then
		return
	end

	local selected = e.selected_prototype
	if not selected then
		return
	end

	local recipe = util.get_selected_recipe(selected)
	if not recipe then
		return
	end

	player.begin_crafting({ recipe = recipe, count = 5 })
end

local quick_craft = {}

quick_craft.events = {
	["cen-quick-craft"] = on_quick_craft,
}

return quick_craft
