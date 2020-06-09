local cen_gui = {}

local gui = require("__flib__.gui")

gui.add_templates{
  titlebar = function(caption, include_close_button)
    return {type="flow", save_as="titlebar_flow", children={
      {type="label", style="frame_title", caption=caption, elem_mods={ignored_by_interaction=true}},
      {type="empty-widget", style="draggable_space", style_mods={height=24, left_margin=4, right_margin=include_close_button and 4 or 0,
        horizontally_stretchable=true}, elem_mods={ignored_by_interaction=true}},
      {type="condition", condition=include_close_button, children={
        {type="sprite-button", style="frame_action_button", sprite="utility/close_white", hovered_sprite="utility/close_black",
          clicked_sprite="utility/close_black", handlers="close_button"}
      }}
    }}
  end
}

gui.add_handlers{
  close_button = {
    on_gui_click = function(e)
      -- gui.handlers.window.on_gui_closed{player_index=e.player_index}
      game.get_player(e.player_index).opened = nil
    end
  },
  window = {
    on_gui_closed = function(e)
      cen_gui.close(game.get_player(e.player_index), global.players[e.player_index])
    end
  }
}

function cen_gui.create(player, player_table)
  local elems = gui.build(player.gui.screen, {
    {type="frame", style="standalone_inner_frame_in_outer_frame", direction="vertical", elem_mods={visible=false}, handlers="window", save_as="window",
      children={
        -- TITLEBAR
        gui.templates.titlebar({"cen-gui.cursor-scroll-config"}, true),
        {type="frame", style="inside_shallow_frame", direction="vertical", children={
          -- TOOLBAR
          {type="frame", style="subheader_frame", children={
            {type="empty-widget", style_mods={horizontally_stretchable=true}}
          }},
          --! TESTING
          {type="flow", style_mods={padding=12}, direction="vertical", children={
            {type="flow", style_mods={vertical_align="center"}, children={
              {type="frame", style="cen_path_frame", children={
                {type="table", style="slot_table", column_count=5, children={
                  {type="choose-elem-button", style="slot_button", elem_type="item", item="transport-belt"},
                  {type="choose-elem-button", style="slot_button", elem_type="item", item="fast-transport-belt"},
                  {type="choose-elem-button", style="slot_button", elem_type="item", item="express-transport-belt"},
                  {type="choose-elem-button", style="slot_button", elem_type="item"},
                }}
              }}
            }}
          }}
        }}
      }
    }
  })

  elems.titlebar_flow.drag_target = elems.window
  elems.window.force_auto_center()

  player_table.gui = elems
end

function cen_gui.destroy(player, player_table)
  gui.remove_player_filters(player.index)
  player_table.gui.window.destroy()
end

function cen_gui.open(player, player_table)
  -- TODO update GUI first
  player_table.gui.window.visible = true
  player_table.flags.config_gui_open = true
  player.set_shortcut_toggled("cen-toggle-config-gui", true)

  player.opened = player_table.gui.window
end

function cen_gui.close(player, player_table)
  player_table.gui.window.visible = false
  player_table.flags.config_gui_open = false
  player.set_shortcut_toggled("cen-toggle-config-gui", false)
end

function cen_gui.toggle(player, player_table)
  if player_table.flags.config_gui_open then
    cen_gui.close(player, player_table)
  else
    cen_gui.open(player, player_table)
  end
end

return cen_gui