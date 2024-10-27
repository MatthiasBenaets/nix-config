{
  services.aerospace = {
    enable = true;

    settings = {
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };
      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        cmd-h = "focus left";
        cmd-j = "focus down";
        cmd-k = "focus up";
        cmd-l = "focus right";
        cmd-left = "focus left";
        cmd-down = "focus down";
        cmd-up = "focus up";
        cmd-right = "focus right";

        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";
        cmd-shift-left = "move left";
        cmd-shift-down = "move down";
        cmd-shift-up = "move up";
        cmd-shift-right = "move right";

        alt-tab = "workspace-back-and-forth";

        cmd-shift-minus = "resize smart -50";
        cmd-shift-equal = "resize smart +50";

        alt-left = "workspace --wrap-around prev";
        alt-right = "workspace --wrap-around next";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";

        alt-shift-left = [ "move-node-to-workspace --wrap-around prev" "workspace --wrap-around prev" ];
        alt-shift-right = [ "move-node-to-workspace --wrap-around next" "workspace --wrap-around next" ];

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        alt-shift-semicolon = "mode service";
      };
      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];
      };
      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "10" = "secondary";
      };
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      key-mapping.preset = "qwerty";
      # start-at-login = true;
    };
  };
}
