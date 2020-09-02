local constants = {}

constants.default_overrides = {
  ["base"] = {
    -- electric poles
    ["small-electric-pole"] = "medium-electric-pole",
    ["medium-electric-pole"] = "big-electric-pole",
    ["big-electric-pole"] = "substation",
    -- inserters
    ["burner-inserter"] = "inserter",
    ["inserter"] = "long-handed-inserter",
    ["long-handed-inserter"] = "fast-inserter",
    ["fast-inserter"] = "filter-inserter",
    ["filter-inserter"] = "stack-inserter",
    ["stack-inserter"] = "stack-filter-inserter",
    -- logistic chests
    ["logistic-chest-requester"] = "logistic-chest-buffer",
    ["logistic-chest-buffer"] = "logistic-chest-storage",
    ["logistic-chest-storage"] = "logistic-chest-passive-provider",
    ["logistic-chest-passive-provider"] = "logistic-chest-active-provider",
    ["logistic-chest-active-provider"] = "steel-chest"
  }
}

constants.direction_to_grade = {
  previous = "downgrade",
  next = "upgrade"
}

constants.item_scroll_input_names = {
  "cen-scroll-next",
  "cen-scroll-previous",
}

constants.path_frame_columns = 5
constants.path_frame_max_rows = 3

constants.setting_name_mapping = {
  ["cen-spawn-items-when-cheating"] = "spawn_items_when_cheating",
  ["cen-ghost-cursor-transitions"] = "ghost_cursor_transitions"
}

return constants