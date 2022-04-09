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

```sudo nixos-rebuild switch --flake .#<host>```
on nixos-unstable

On fresh NixOs-unstable install:

- Do your partitioning/formatting
- ```sudo su```
- ```nix-env -iA nixos.git```
- ```mount /dev/disk/by-label/nixos /mnt```
  - If UEFI:
  - ```mkdir -p /mnt/boot```
  - ```mount /dev/disk/by-label/boot /mnt/boot```
  - Mount other existing drives to their respective locations
- ```nixos-generate-config --root /mnt```
- ```git clone https://github.com/matthiasbenaets/nixos-config /mnt/etc/nixos/setup```
- Optional (current config works with labels not uuid's)
  - ```cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/setup/hosts/<host>/hardware-configuration.nix```
- ```rm /mnt/etc/nixos/configuration.nix```
- Change username in ```/mnt/etc/nixos/setup/flake.nix``` if you are not me.
- Edit ```/mnt/etc/nixos/setup/hosts/<host>/default.nix```:
  - Change loader settings depending on Legacy Boot vs. UEFI
  - Edit networking interfaces
     - Either ```ip a``` or look in ```/mnt/etc/nixos/configuration.nix```
  - Set emacs to commented out in ```/mnt/etc/nixos/modules/editors/default.nix ```
     - Better to rebuild with it uncommented after installation to correctly install doom emacs.
- ```cd /mnt/etc/nixos/setup/```
- ```nixos-install --flake .#<host>```
- Set root password and reboot
- If no users.users.initialPassword is set:
  - Log into tty with root ```Ctrl - Alt - F1```
  - ```passwd <user>```
  - ```Ctrl - Alt - F7```
- Log in with LightDM
- Optional
  - Move ```/etc/nixos/setup``` to other location and change permission to user:users
  - ```nixos-rebuild switch --flake .#<host>``` to rebuild correctly and install doom emacs.

If dual booting - rebuild once more if OS Prober can't find other partitions.
