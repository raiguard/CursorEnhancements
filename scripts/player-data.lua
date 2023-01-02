local player_data = {}

local constants = require("constants")

function player_data.init(player_index, player)
	global.players[player_index] = {
		last_build_tick = 0,
		last_item = nil,
		main_inventory = player.get_main_inventory(),
		settings = {},
	}
end

function player_data.update_settings(player, player_table)
	local player_settings = player.mod_settings
	local saved_settings = player_table.settings
	for setting_name, save_as in pairs(constants.setting_name_mapping) do
		saved_settings[save_as] = player_settings[setting_name].value
	end
end

function player_data.update_personal_overrides(player, player_table)
	local registry = {
		next = {},
		previous = {},
	}

	local overrides = game.json_to_table(player.mod_settings["cen-personal-registry-overrides"].value)
	if overrides and type(overrides) == "table" then
		local item_prototypes = game.item_prototypes
		for item, next_item in pairs(overrides) do
			if next_item then
				if item_prototypes[item] and item_prototypes[next_item] then
					local stored_next_item = registry.next[item]
					if stored_next_item then
						registry.previous[stored_next_item] = false
					end
					registry.next[item] = next_item
					registry.previous[next_item] = item
				end
			elseif item_prototypes[item] then
				local stored_next_item = registry.next[item]
				if stored_next_item then
					registry.previous[stored_next_item] = false
				end
				registry.next[item] = false
			end
		end
	else
		player.print({ "cen-message.invalid-personal-overrides-format" })
	end

	player_table.registry = registry
end

function player_data.refresh(player, player_table)
	player_data.update_settings(player, player_table)
	player_data.update_personal_overrides(player, player_table)
end

function player_data.ensure_valid_inventory(player, player_table)
	if not player_table.main_inventory or not player_table.main_inventory.valid then
		player_table.main_inventory = player.get_main_inventory()
	end
end

return player_data
