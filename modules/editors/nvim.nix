#
#  Neovim
#

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
 
        plugins = with pkgs.vimPlugins; [
          editorconfig-vim
          auto-pairs
          indent-blankline-nvim
          lightline-vim
          nerdtree
          #nvim-fzf
          #nvim-lspconfig
          nvim-treesitter.withAllGrammars
          telescope-nvim
          vim-gitgutter
          vim-lastplace

          # themes
          wombat256-vim
          srcery-vim

          # markdown
          vim-markdown

          # nix
          vim-nix

          # svelte
          vim-svelte

          coc-nvim
        ];

        extraPackages = with pkgs; [
          nodejs
          rnix-lsp
          nodePackages.typescript-language-server
          nodePackages.svelte-language-server
        ];

        extraConfig = ''
          colorscheme srcery
          " colorscheme wombat256mod
          syntax on
          filetype plugin indent on

          set shiftwidth=2
          set tabstop=2
          set softtabstop=2
          set number
          set expandtab

          set list
          set listchars=tab:>-

          " Enable clipboard support
          set clipboard=unnamedplus

          " Enable auto-indentation
          filetype plugin indent on

          " Highlighting
          highlight Comment cterm=italic gui=italic
          hi Normal guibg=NONE ctermbg=NONE

          " Set leader
          let mapleader = " "

          " Keybind UndoTree
          nnoremap <F5> :UndotreeToggle<CR>

          " Keybind Nerdtree
          nmap <F6> :NERDTreeToggle<CR>

          " Load Fugitive
          " packadd fugitive

          " Enable LSP
          "lua << EOF
          "require'lspconfig'.rnix.setup{}
          "require'lspconfig'.tsserver.setup{}
          "require'lspconfig'.svelte.setup{}
          "EOF

          "Configure Telescope
          nnoremap <leader>ff :Telescope find_files<CR>
          nnoremap <leader>fg :Telescope live_grep<CR>
          nnoremap <leader>fb :Telescope buffers<CR>
          nnoremap <leader>fh :Telescope help_tags<CR>

          " Lightline
          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }

          let g:coc_config = {
          \ 'languageserver': {
            \ 'svelte': {
              \ 'command': 'svelte-language-server',
              \ 'args': ['--stdio'],
              \ 'filetypes': ['svelte'],
              \ 'initializationOptions': {},
            \ },
          \ },
          \ }
          autocmd FileType * silent! call CocEnable()
        '';
      };
    };
  };
}
