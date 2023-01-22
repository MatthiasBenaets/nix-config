#
# Neovim
#

{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      configure = {
        customRC = ''
          syntax enable
          colorscheme srcery

          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }

          highlight Comment cterm=italic gui=italic
          hi Normal guibg=NONE ctermbg=NONE

          set number

          nmap <F6> :NERDTreeToggle<CR>
        '';
        packages.myVimPackages = with pkgs.vimPlugins; {
          start = [
            vim-nix
            vim-markdown

            vim-lastplace
            auto-pairs
            vim-gitgutter

            nerdtree
            wombat256-vim
            srcery-vim

            lightline-vim
            indent-blankline-nvim
           ];
        };
      };
    };
  };
}
