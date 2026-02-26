{
  flake.modules.editors.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          lua_ls = {
            enable = true;
            settings = {
              diagnostics = {
                globals = [ "vim" ];
              };
              workspace = {
                checkThirdParty = false;
                telemetry = {
                  enable = false;
                };
                library = [
                  "\${3rd}/love2d/library"
                ];
              };
            };
          };
          emmet_ls = {
            enable = true;
            filetypes = [
              "html"
              "css"
              "svelte"
              "elixir"
              "eelixir"
              "heex"
            ];
            onAttach = {
              override = true;
              function = ''
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              '';
            };
          };
          cssls.enable = true;
          elixirls.enable = true;
          eslint.enable = true;
          gopls.enable = true;
          html.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              nix = {
                flake = {
                  autoArchive = true;
                };
              };
              formatting.command = [ "nixfmt" ];
            };
          };
          pyright.enable = true;
          svelte.enable = true;
          vue_ls.enable = true;
          tailwindcss = {
            enable = true;
            settings = {
              filetypes = [
                "html"
                "css"
                "js"
                "jsx"
                "mdx"
                "svelte"
                "ts"
                "tsx"
                "heex"
                "elixir"
                "eelixir"
              ];
              includeLanagues = {
                elixir = "html-eex";
                eelixir = "html-eex";
                heex = "html-eex";
              };
              classAttributes = [
                "class"
                "className"
                "class:list"
                "classList"
                "ngClass"
                ''class[:]\s*"([^"]*)"''
              ];
            };
          };
          ts_ls.enable = true;
          zls.enable = true;
        };
      };
    };
  };
}
