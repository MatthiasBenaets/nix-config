let
  tmux = {
    enable = true;
    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      set -g mouse on
      set-option -g clock-mode-style 24
      set-option -g status-position top

      set -g prefix C-Space

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -g status-style bg=default,fg=blue,bright
    '';
    terminal = "screen-256color";
  };
in
{

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.tmux = tmux;

    };

  flake.modules.darwin.base =
    { config, ... }:
    {
      home-manager.users.${config.host.user.name} = {
        programs.tmux = tmux;
      };
    };
}
