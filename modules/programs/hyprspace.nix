{
  flake.modules.darwin.hyprspace =
    { config, pkgs, ... }:
    {
      homebrew = {
        enable = true;
        casks = [
          "BarutSRB/tap/hyprspace"
        ];
      };

      home-manager.users.${config.host.user.name} = {
        home.packages = with pkgs; [ jankyborders ];
        home.file.".hyprspace.toml".text = ''
          # Startup & Lifecycle
          start-at-login = true
          after-startup-command = [
            'exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xffa6a6a6 inactive_color=0x00a6a6a6 style=round width=5.0'
          ]

          # Default Layout Settings
          default-root-container-layout = "dwindle"
          default-root-container-orientation = "auto"

          # Dwindle Layout
          dwindle-default-split-ratio = 1.0
          dwindle-single-window-aspect-ratio = [0, 0]
          dwindle-single-window-aspect-ratio-tolerance = 0.1
          #mouse-sensitivity = 0.5

          # Other Layout Settings
          accordion-padding = 30

          # Normalization Settings
          enable-normalization-flatten-containers = true

          # MacOS Integration
          automatically-unhide-macos-hidden-apps = true

          # Gaps
          [gaps]
          inner.horizontal = 8
          inner.vertical = 8
          outer.left = 8
          outer.bottom = 8
          outer.top = 8
          outer.right = 8

          # Workspace to Monitor Assignment
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

          # Key Mappings
          [key-mapping]
          preset = "qwerty"

          # Main Mode Bindings
          [mode.main.binding]
            # alt = General and Node Focus
            # alt-shift = Move Node
            # ctrl-alt = Workspace Focus
            # ctrl-alt-shift = Move Node to Workspace

          ## Focus Movement
          alt-left = "focus --boundaries all-monitors-outer-frame left"
          alt-down = "focus --boundaries all-monitors-outer-frame down"
          alt-up = "focus --boundaries all-monitors-outer-frame up"
          alt-right = "focus --boundaries all-monitors-outer-frame right"
          alt-h = "focus --boundaries all-monitors-outer-frame left"
          alt-j = "focus --boundaries all-monitors-outer-frame down"
          alt-k = "focus --boundaries all-monitors-outer-frame up"
          alt-l = "focus --boundaries all-monitors-outer-frame right"

          ## Window Movement
          alt-shift-left = "move left --boundaries all-monitors-outer-frame"
          alt-shift-down = "move down --boundaries all-monitors-outer-frame"
          alt-shift-up = "move up --boundaries all-monitors-outer-frame"
          alt-shift-right = "move right --boundaries all-monitors-outer-frame"
          alt-shift-h = "move left --boundaries all-monitors-outer-frame"
          alt-shift-j = "move down --boundaries all-monitors-outer-frame"
          alt-shift-k = "move up --boundaries all-monitors-outer-frame"
          alt-shift-l = "move right --boundaries all-monitors-outer-frame"

          ## Workspace Switching
          ctrl-alt-left = "workspace prev"
          ctrl-alt-right = "workspace next"
          # ctrl-alt-left = "workspace --wrap-around prev"
          # ctrl-alt-right = "workspace --wrap-around next"
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
          ctrl-alt-shift-left = [ "move-node-to-workspace prev", "workspace prev" ]
          ctrl-alt-shift-right = [ "move-node-to-workspace next", "workspace next" ]
          # ctrl-alt-shift-left = [ "move-node-to-workspace --wrap-around prev", "workspace --wrap-around prev" ]
          # ctrl-alt-shift-right = [ "move-node-to-workspace --wrap-around next", "workspace --wrap-around next" ]
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
          ctrl-alt-shift-z = "move-node-to-monitor --wrap-around --focus-follows-window next"
          alt-tab = "workspace-back-and-forth"
          alt-m = [ "move-node-to-monitor --wrap-around next", "focus-monitor --wrap-around next" ]

          ## Layout Command
          alt-slash = "layout tiles horizontal vertical"
          alt-comma = "layout accordion horizontal vertical"
          alt-f = "layout floating tiling"
          alt-shift-f = "fullscreen"


          ## Window Resizing
          alt-minus = "resize smart -100"
          alt-equal = "resize smart +100"


          ## Window Management
          alt-q = "close --quit-if-last-window"

          ## Exec Commands
          alt-enter = "exec-and-forget /Applications/kitty.app/Contents/MacOS/kitty ~"
          alt-e = "exec-and-forget open ~"

          # Service Mode
          alt-shift-semicolon = "mode service"
          [mode.service.binding]

          # Window Detection Rules
          [[on-window-detected]]
          if.app-id = "org.mozilla.firefox"
          if.window-title-regex-substring = "Picture-in-Picture"
          run = "layout floating"

          [[on-window-detected]]
          if.app-id = 'com.google.Chrome'
          if.window-title-regex-substring = 'Picture in Picture'
          run = 'layout floating'
          check-further-callbacks = true
        '';
      };
    };
}
