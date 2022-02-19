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

      plugins = with pkgs.vimPlugins; [

        vim-nix               # Syntax Highlighting nix

        # QoL
        vim-lastplace         # Opens document where you left it
        auto-pairs            # Print double quotes/brackets/etc.

        # File Tree
	nerdtree              # File Manager - set in extraConfig to F6
	
        # Customization 
        wombat256-vim         # Color scheme for lightline
        #gruvbox              # Color scheme for text:  gruvbox
        srcery-vim            #                         srcery


        lightline-vim         # Info bar at bottom
	indent-blankline-nvim # Indentation lines
      ];

      extraConfig = ''
        syntax enable
        colorscheme srcery

        let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }

        highlight Comment cterm=italic gui=italic
        hi Normal guibg=NONE ctermbg=NONE

        nmap <F6> :NERDTreeToggle<CR>
      '';
    };
  };
}

