{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    let
      livesvelte = pkgs.stdenv.mkDerivation {
        name = "livesvelte";
        version = "v0.16.0";
        buildCommand = ''
          mkdir -p $out/queries/elixir
          cat > $out/queries/elixir/injections.scm << 'EOF'
          ; extends

          ; Svelte
          (sigil
            (sigil_name) @_sigil_name
            (quoted_content) @injection.content
           (#eq? @_sigil_name "V")
           (#set! injection.language "svelte"))
          EOF
        '';
      };
    in
    {
      plugins = {
        treesitter = {
          enable = true;
          nixvimInjections = true;
          folding.enable = false;
          nixGrammars = true;
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [ livesvelte ];
          settings = {
            ensure_installed = "all";
            highlight.enable = true;
            incremental_selection.enable = true;
            indent.enable = true;
          };
        };
      };

      extraPlugins = [
        livesvelte
      ];
    };
}
