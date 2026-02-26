{
  flake.modules.editors.nixvim = {
    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "-";
            };
            topdelete = {
              text = "-";
            };
            changedelete = {
              text = "~";
            };
            untracked = {
              text = "x";
            };
          };
          signs_staged = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "-";
            };
            topdelete = {
              text = "-";
            };
            changedelete = {
              text = "~";
            };
            untracked = {
              text = "x";
            };
          };
        };
      };
    };
  };
}
