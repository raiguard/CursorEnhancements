local constants = require("constants")

local styles = data.raw["gui-style"].default

styles.cen_path_frame = {
  type = "frame_style",
  parent = "slot_button_deep_frame",
  minimal_width = constants.path_frame_columns * 40,
  right_margin = 12
}