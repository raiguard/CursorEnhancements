local spawn_item_tooltip = {
  "",
  {"mod-setting-description.cen-spawn-items-when-cheating"},
  mods["space-exploration"]
    and {"", "\n\n", {"mod-setting-description.cen-spawn-items-when-cheating-se-addendum"}}
    or ""
}

data:extend{
  {
    type = "bool-setting",
    name = "cen-spawn-items-when-cheating",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "a",
    localised_description = spawn_item_tooltip
  },
  {
    type = "bool-setting",
    name = "cen-ghost-cursor-transitions",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "b"
  },
  {
    type = "string-setting",
    name = "cen-belt-scroll-type",
    setting_type = "runtime-per-user",
    allowed_values = {
      "levels",
      "types",
      "levels-then-types",
      "types-then-levels"
    },
    default_value = "levels",
    order = "c"
  },
  {
    type = "string-setting",
    name = "cen-personal-registry-overrides",
    setting_type = "runtime-per-user",
    default_value = "{}",
    order = "d"
  }
}
