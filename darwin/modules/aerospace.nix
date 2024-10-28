{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.packages = [ pkgs.aerospace ];
    xdg.configFile."aerospace/aerospace.toml".text = ''
      start-at-login = true
      accordion-padding = 30
      default-root-container-layout = "tiles"
      default-root-container-orientation = "auto"
      key-mapping.preset = "qwerty"

      [gaps]
      inner.horizontal = 8
      inner.vertical = 8
      outer.left = 8
      outer.bottom = 8
      outer.top = 8
      outer.right = 8

      [mode.main.binding]
      # alt = General and Node Focus
      # alt-shift = Move Node
      # ctrl-alt = Workspace Focus
      # ctrl-alt-shift = Move Node to Workspace

      alt-slash = "layout tiles horizontal vertical"
      alt-comma = "layout accordion horizontal vertical"
      alt-f = "layout floating tiling"
      alt-shift-f = "fullscreen"

      alt-tab = "workspace-back-and-forth"
      alt-m = [ "move-node-to-monitor --wrap-around next", "focus-monitor --wrap-around next" ]

      alt-minus = "resize smart -50"
      alt-equal = "resize smart +50"

      alt-q = "close --quit-if-last-window"

      alt-left = "focus --boundaries all-monitors-outer-frame left"
      alt-down = "focus --boundaries all-monitors-outer-frame down"
      alt-up = "focus --boundaries all-monitors-outer-frame up"
      alt-right = "focus --boundaries all-monitors-outer-frame right"
      alt-h = "focus --boundaries all-monitors-outer-frame left"
      alt-j = "focus --boundaries all-monitors-outer-frame down"
      alt-k = "focus --boundaries all-monitors-outer-frame up"
      alt-l = "focus --boundaries all-monitors-outer-frame right"

      alt-shift-left = "move left"
      alt-shift-down = "move down"
      alt-shift-up = "move up"
      alt-shift-right = "move right"
      alt-shift-h = "move left"
      alt-shift-j = "move down"
      alt-shift-k = "move up"
      alt-shift-l = "move right"

      ctrl-alt-left = "workspace --wrap-around prev"
      ctrl-alt-right = "workspace --wrap-around next"
      ctrl-alt-1 = "workspace 1"
      ctrl-alt-2 = "workspace 2"
      ctrl-alt-3 = "workspace 3"
      ctrl-alt-4 = "workspace 4"
      ctrl-alt-5 = "workspace 5"
      ctrl-alt-6 = "workspace 6"
      ctrl-alt-7 = "workspace 7"
      ctrl-alt-8 = "workspace 8"
      ctrl-alt-9 = "workspace 9"
      ctrl-alt-0 = "workspace 10"

      ctrl-alt-shift-left = [ "move-node-to-workspace --wrap-around prev", "workspace --wrap-around prev" ]
      ctrl-alt-shift-right = [ "move-node-to-workspace --wrap-around next", "workspace --wrap-around next" ]
      ctrl-alt-shift-1 = "move-node-to-workspace 1"
      ctrl-alt-shift-2 = "move-node-to-workspace 2"
      ctrl-alt-shift-3 = "move-node-to-workspace 3"
      ctrl-alt-shift-4 = "move-node-to-workspace 4"
      ctrl-alt-shift-5 = "move-node-to-workspace 5"
      ctrl-alt-shift-6 = "move-node-to-workspace 6"
      ctrl-alt-shift-7 = "move-node-to-workspace 7"
      ctrl-alt-shift-8 = "move-node-to-workspace 8"
      ctrl-alt-shift-9 = "move-node-to-workspace 9"
      ctrl-alt-shift-0 = "move-node-to-workspace 10"

      alt-enter = "exec-and-forget /Applications/kitty.app/Contents/MacOS/kitty ~"

      alt-shift-semicolon = "mode service"

      [mode.service.binding]
      esc = [ "reload-config", "mode main" ]
      r = [ "flatten-workspace-tree", "mode main" ]
      f = [ "layout floating tiling", "mode main" ]
      backspace = [ "close-all-windows-but-current", "mode main" ]

      alt-shift-left = [ "join-with left", "mode main" ]
      alt-shift-down = [ "join-with down", "mode main" ]
      alt-shift-up = [ "join-with up", "mode main" ]
      alt-shift-right = [ "join-with right", "mode main" ]
      alt-shift-h = [ "join-with left", "mode main" ]
      alt-shift-j = [ "join-with down", "mode main" ]
      alt-shift-k = [ "join-with up", "mode main" ]
      alt-shift-l = [ "join-with right", "mode main" ]

      [workspace-to-monitor-force-assignment]
      "1" = "main"
      "2" = "main"
      "3" = "main"
      "4" = "main"
      "5" = "main"
      "6" = "secondary"
      "7" = "secondary"
      "8" = "secondary"
      "9" = "secondary"
      "10" = "secondary"

      [[on-window-detected]]
      if.app-id = "org.mozilla.firefox"
      if.window-title-regex-substring = "Picture-in-Picture"
      run = "layout floating"
    '';
  };
}
