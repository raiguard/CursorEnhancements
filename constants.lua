local constants = {}

constants.blacklisted_item_types = {
  ["blueprint"] = true,
  ["blueprint-book"] = true,
  ["copy-paste-tool"] = true,
  ["deconstruction-item"] = true,
  ["selection-tool"] = true,
  ["upgrade-item"] = true,
}

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
    -- tiles
    ["landfill"] = "stone-brick",
    ["stone-brick"] = "concrete",
    ["concrete"] = "hazard-concrete",
    ["hazard-concrete"] = "refined-concrete",
    ["refined-concrete"] = "refined-hazard-concrete",
  },
  ["deadlock-beltboxes-loaders"] = {
    ["express-transport-belt-loader"] = "ultra-fast-belt-loader",
    ["ultra-fast-belt-loader"] = "extreme-fast-belt-loader",
    ["extreme-fast-belt-loader"] = "ultra-express-belt-loader",
    ["ultra-express-belt-loader"] = "extreme-express-belt-loader",
    ["extreme-express-belt-loader"] = "ultimate-belt-loader",
  },
  ["UltimateBelts"] = {
    ["express-transport-belt"] = "ultra-fast-belt",
    ["ultra-fast-belt"] = "extreme-fast-belt",
    ["extreme-fast-belt"] = "ultra-express-belt",
    ["ultra-express-belt"] = "extreme-express-belt",
    ["extreme-express-belt"] = "ultimate-belt",
    ["express-underground-belt"] = "ultra-fast-underground-belt",
    ["ultra-fast-underground-belt"] = "extreme-fast-underground-belt",
    ["extreme-fast-underground-belt"] = "ultra-express-underground-belt",
    ["ultra-express-underground-belt"] = "extreme-express-underground-belt",
    ["extreme-express-underground-belt"] = "original-ultimate-underground-belt",
    ["express-splitter"] = "ultra-fast-splitter",
    ["ultra-fast-splitter"] = "extreme-fast-splitter",
    ["extreme-fast-splitter"] = "ultra-express-splitter",
    ["ultra-express-splitter"] = "extreme-express-splitter",
    ["extreme-express-splitter"] = "original-ultimate-splitter",
  },
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
  ["cen-ghost-cursor-transitions"] = "ghost_cursor_transitions",
  ["cen-enable-tile-pipette"] = "tile_pipette",
}

return constants
