set packpath^=/nix/store/l4ywgs56a0jw8x955s3gilw8an7dbpbv-vim-pack-dir
set runtimepath^=/nix/store/l4ywgs56a0jw8x955s3gilw8an7dbpbv-vim-pack-dir

syntax enable                             " Syntax highlighting
colorscheme srcery                        " Color scheme text

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ }                                     " Color scheme lightline

highlight Comment cterm=italic gui=italic " Comments become italic
hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

set number                                " Set numbers

nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
