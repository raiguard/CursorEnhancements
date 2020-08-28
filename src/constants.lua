local constants = {}

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