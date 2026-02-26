{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      plugins = {
        cmp = {
          enable = true;
          settings = {
            snippet.expand = "luasnip";
            mapping = {
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.close()";
              "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<C-y>" = "cmp.mapping.confirm({ select = true })";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            formatting = {
              format = ''
                function(entry, vim_item)
                  local source_names = {
                    nvim_lsp = "[LSP]",
                    luasnip = "[SNIP]",
                    buffer = "[BUF]",
                    path = "[PATH]",
                  }
                  vim_item.menu = source_names[entry.source.name] or ""
                  return vim_item
                end
              '';
            };
            completion.completeopt = "menu,menuone,noinsert,preview";
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        luasnip
      ];
    };
}
