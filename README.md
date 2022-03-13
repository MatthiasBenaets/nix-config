# Nix Dotfiles

|||
|---|---|
|**Shell:**|zsh|
|**DM:**|lightdm|
|**WM:**|bspwm + polybar|
|**Editor:**|nvim + doom emacs|
|**Terminal:**|alacritty|
|**Launcher:**|rofi|
|**GTK Theme:**|dracula|

## THIS README IS A PLACEHOLDER

Build with:

```sudo nixos-rebuild switch --flake .#$DEVICE```
on nixos-unstable

On fresh NixOs-unstable install:

- Do your partitioning/formatting
- ```sudo su```
- ```nix-env -iA nixos.git```
- ```mount /dev/disk/by-label/nixos /mnt```
  - If UEFI:
  - ```mkdir -p /mnt/boot```
  - ```mount /dev/disk/by-label/boot /mnt/boot```
- ```nixos-generate-config --root /mnt```
- ```git clone https://github.com/matthiasbenaets/nix-dotfiles /mnt/etc/nixos/dotfiles```
- ```cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/dotfiles/hosts/$HOST/hardware-configuration.nix```
- ```rm /mnt/etc/nixos/configuration.nix```
- Edit /mnt/etc/nixos/dotfiles/hosts/$HOST/default.nix
  - Change loader settings depending on Legacy Boot vs. UEFI
  - Edit networking interfaces
     - Either ```ip a``` or look in /mnt/etc/nixos/configuration.nix
  - Uncomment emacs in modules/editors/default.nix 
     - Better to rebuild with it uncomment after installation to correctly install doom emacs.
- ```cd /mnt/etc/nixos/dotfiles/```
- ```nixos-install --flake .#$HOST```
- Set root password and Reboot
- Log into tty with root ```Ctrl - Alt - F1```
- ```passwd $USER```
- ```Ctrl - Alt - F7```
- Log in with LightDM
- Enjoy

if dual booting - rebuild once more if OS Prober can't find other partitions.
