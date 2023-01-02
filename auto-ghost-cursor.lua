local util = require("__CursorEnhancements__/util")

--- @param e EventData.on_player_cursor_stack_changed
local function on_player_cursor_stack_changed(e)
	local player = game.get_player(e.player_index)
	if not player then
		return
	end

	if not player.mod_settings["cen-auto-ghost-cursor"].value then
		return
	end

	local built_item = global.built_item[e.player_index]
	if not built_item then
		return
	end
	global.built_item[e.player_index] = nil

	-- Don't do anything if the cursor stack is not empty
	local cursor_stack = player.cursor_stack
	if not cursor_stack or cursor_stack.valid_for_read then
		return
	end

	util.set_cursor(player, built_item)
end

--- @param e EventData.on_pre_build
local function on_pre_build(e)
	local player = game.get_player(e.player_index)
	if not player then
		return
	end

	if not player.mod_settings["cen-auto-ghost-cursor"].value then
		return
	end

	local cursor_stack = player.cursor_stack
	if not cursor_stack or not cursor_stack.valid_for_read then
		return
	end

	global.built_item[e.player_index] = cursor_stack.name
end

--- @param e EventData.on_player_main_inventory_changed
local function on_player_main_inventory_changed(e)
	local player = game.get_player(e.player_index)
	if not player then
		return
	end

	if not player.mod_settings["cen-auto-ghost-cursor"].value then
		return
	end

	local cursor_ghost = player.cursor_ghost
	if not cursor_ghost then
		return
	end

	local main_inventory = player.get_main_inventory()
	if not main_inventory then
		return
	end

	local count = main_inventory.get_item_count(cursor_ghost.name)
	if count == 0 then
		return
	end
	util.set_cursor(player, cursor_ghost.name)
end

local auto_ghost_cursor = {}

auto_ghost_cursor.on_init = function()
	--- @type table<uint, string?>
	global.built_item = {}
end

auto_ghost_cursor.events = {
	[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed,
	[defines.events.on_player_main_inventory_changed] = on_player_main_inventory_changed,
	[defines.events.on_pre_build] = on_pre_build,
}

return auto_ghost_cursor
