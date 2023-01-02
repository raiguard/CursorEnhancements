--- @class Util
local util = {}

--- @param player LuaPlayer
--- @return boolean
function util.is_cheating(player)
	if player.cheat_mode and not script.active_mods["space-exploration"] then
		return true
	end
	return player.controller_type == defines.controllers.editor
end

--- @param player LuaPlayer
--- @param item string
--- @return boolean success
function util.set_cursor(player, item)
	local inventory = player.get_main_inventory()
	if not inventory then
		return false
	end
	local cursor_stack = player.cursor_stack
	if not cursor_stack or not player.clear_cursor() then
		return false
	end
	local inventory_stack, stack_index = inventory.find_item_stack(item)
	if not inventory_stack or not stack_index then
		local stack_size = game.item_prototypes[item].stack_size
		if not util.is_cheating(player) then
			player.cursor_ghost = item
			return true
		elseif
			player.mod_settings["cen-spawn-items-when-cheating"].value
			and inventory.can_insert({ name = item, count = stack_size })
		then
			inventory.insert({ name = item, count = stack_size })
			inventory_stack, stack_index = inventory.find_item_stack(item)
		else
			return false
		end
	end
	--- @cast inventory_stack LuaItemStack
	--- @cast stack_index uint
	if not cursor_stack.transfer_stack(inventory_stack) then
		return false
	end
	player.hand_location = {
		inventory = defines.inventory.character_main,
		slot = stack_index,
	}
	return true
end

return util
