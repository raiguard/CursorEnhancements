local constants = {}

constants.default_overrides = {
  ["base"] = {
    -- circuits
    ["red-wire"] = "green-wire",
    ["green-wire"] = "small-lamp",
    ["small-lamp"] = "arithmetic-combinator",
    ["arithmetic-combinator"] = "decider-combinator",
    ["decider-combinator"] = "constant-combinator",
    ["constant-combinator"] = "power-switch",
    ["power-switch"] = "programmable-speaker",
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
    ["steel-chest"] = "logistic-chest-active-provider",
    ["logistic-chest-active-provider"] = "logistic-chest-passive-provider",
    ["logistic-chest-passive-provider"] = "logistic-chest-storage",
    ["logistic-chest-storage"] = "logistic-chest-buffer",
    ["logistic-chest-buffer"] = "logistic-chest-requester",
    -- pipes
    ["pipe"] = "pipe-to-ground",
    -- rails
    ["rail"] = "rail-signal",
    ["rail-signal"] = "rail-chain-signal",
    ["rail-chain-signal"] = "train-stop",
    -- trains
    ["locomotive"] = "cargo-wagon",
    ["cargo-wagon"] = "fluid-wagon",
    ["fluid-wagon"] = "artillery-wagon",
    -- vanilla loaders
    ["loader"] = "fast-loader",
    ["fast-loader"] = "express-loader"
  }
}

constants.interface_version = 1

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
