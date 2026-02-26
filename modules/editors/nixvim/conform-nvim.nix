{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPackages = with pkgs; [
        black
        isort
        nixfmt
        prettier
        stylua
      ];

      plugins = {
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              javascript = [ "prettier" ];
              typescript = [ "prettier" ];
              typescriptreact = [ "prettier" ];
              svelte = [ "prettier" ];
              vue = [ "prettier" ];
              css = [ "prettier" ];
              html = [ "prettier" ];
              json = [ "prettier" ];
              yaml = [ "prettier" ];
              markdown = [ "prettier" ];
              lua = [ "stylua" ];
              php = [ "prettier" ];
              python = [
                "isort"
                "black"
              ];
              nix = [ "nixfmt" ];
            };
            format_on_save = ''
              function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
                end
                return { timeout_ms = 1000, lsp_fallback = true }, on_format
               end
            '';
          };
        };
      };
    };
}
