{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPackages = with pkgs; [
        black
        isort
        nixfmt
        prettier
        phpPackages.php-cs-fixer
        rustfmt
        stylua
      ];

      plugins = {
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              css = [ "prettier" ];
              html = [ "prettier" ];
              javascript = [ "prettier" ];
              json = [ "prettier" ];
              lua = [ "stylua" ];
              markdown = [ "prettier" ];
              nix = [ "nixfmt" ];
              php = [ "php_cs_fixer" ];
              python = [
                "isort"
                "black"
              ];
              rust = {
                __unkeyed-1 = "rustfmt";
                lsp_fallback = true;
              };
              svelte = [ "prettier" ];
              typescript = [ "prettier" ];
              typescriptreact = [ "prettier" ];
              vue = [ "prettier" ];
              yaml = [ "prettier" ];
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
