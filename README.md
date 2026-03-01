# Matthias' Nix Configuration Flake

A modular, multi-platform Nix flake managing NixOS, Nix-Darwin, and standalone Home Manager configurations using [flake-parts](https://flake.parts) and the [dendritic pattern](https://github.com/mightyiam/dendritic).

---

## Overview

This flake manages system configuration across three platforms:

- **NixOS** - full system configuration for Linux hosts
- **nix-darwin** - system configuration for macOS hosts
- **Home Manager (standalone)** - user environment for non-NixOS Linux hosts
- **Dev Shells** - reproducible development environments via `nix develop`
- **Packages** - standalone applications (e.g. neovim via nixvim) runnable with `nix run`

### Architecture

The flake uses [flake-parts](https://flake.parts) with [import-tree](https://github.com/vic/import-tree) to automatically load all modules from the `modules/` directory. Configuration is split into small, composable modules following the dendritic pattern. Modules are organized by feature, not by target OS, and hosts compose exactly what they need.

---

## Hosts

### NixOS

| Host      | WM / DE  | Shell    | Terminal | Notes   |
| --------- | -------- | -------- | -------- | ------- |
| `beelink` | Hyprland | Noctalia | Kitty    | Desktop |
| `work`    | Hyprland | Noctalia | Kitty    | Laptop  |
| `vm`      | None     | None     | Nonve    | None    |

### Nix-Darwin

| Host    | WM        | Shell | System         | Notes          |
| ------- | --------- | ----- | -------------- | -------------- |
| `intel` | None      | Zsh   | x86_64-darwin  | MacBook Intel  |
| `m1`    | HyprSpace | Zsh   | aarch64-darwin | MacBook Air M1 |
| `work`  | HyprSpace | Zsh   | aarch64-darwin | MacBook Air M3 |

### Standalone Home Manager

| Host     | System       | Notes                               |
| -------- | ------------ | ----------------------------------- |
| `pacman` | x86_64-linux | Any Linux distro with Nix installed |

### All hosts

| Shell      | Editors         | Terminal |
| ---------- | --------------- | -------- |
| Zsh + p10k | Neovim (nixvim) | Kitty    |

---

## Installation

### NixOS

```bash
# Clone the repo
git clone https://github.com/matthiasbenaets/nixos-config ~/.setup
cd ~/.setup

# Switch to a host configuration
sudo nixos-rebuild switch --flake <path/to/flake>#<host>

# Example
sudo nixos-rebuild switch --flake .#beelink
```

### Nix-Darwin

First install Nix if not present:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Enable flakes:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

First build (darwin-rebuild not yet in PATH):

```bash
nix-env -iA nixpkgs.git
git clone https://github.com/matthiasbenaets/nixos-config ~/.setup
cd ~/.setup
nix build .#darwinConfigurations.<host>.system
./result/sw/bin/darwin-rebuild switch --flake <path/to/flake>#<host>
```

Subsequent rebuilds:

```bash
darwin-rebuild switch --flake <path/to/flake>#<host>
```

### Standalone Home Manager

First install Nix:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Initial build:

```bash
nix-env -iA nixpkgs.git
git clone https://github.com/matthiasbenaets/nixos-config ~/.setup
cd ~/.setup
nix build --extra-experimental-features 'nix-command flakes' <path/to/flake>#homeConfigurations.<host>.activationPackage
./result/activate
```

Subsequent rebuilds:

```bash
home-manager switch --flake <path/to/flake>#<host>
```

---

## Adding a New Host

Thanks to the dendritic structure and `import-tree`, adding a new host is a straightforward process that doesn't require modifying the main `flake.nix`.

Here's how to add a new NixOS host (the process is similar for `nix-darwin` and `home-manager`):

1.  **Create a Host Directory**:
    Create a new directory for your host under `modules/hosts/nixos/`. Let's call it `my-new-host`:

    ```bash
    mkdir modules/hosts/nixos/my-new-host
    ```

2.  **Create a `default.nix`**:
    Inside the new directory, create a `default.nix` file. This is where you'll define your host's configuration. You can use an existing host as a template.

3.  **Define the Host Configuration**:
    In `modules/hosts/nixos/my-new-host/default.nix`, define the `nixosConfiguration` for your host. It should look something like this:

    ```nix
    {
      config,
      inputs,
      ...
    }:

    let
      host = {
        name = "my-new-host";
        user.name = "your-username";
        state.version = "23.11"; // Or your desired version
        system = "x86_64-linux";
      };
    in
    {
      flake.nixosConfigurations.my-new-host = inputs.nixpkgs.lib.nixosSystem {
        modules = with config.flake.modules.nixos; [
          # Import the modules you need
          base
          my-new-host # a module for host specific configuration

          # Example modules:
          audio
          nixvim
          gnome
        ];
      };

      # Host-specific module
      flake.modules.nixos.my-new-host = {
        inherit host;
        home-manager.users.${host.user.name} = {
          imports = with config.flake.modules.homeManager; [
            # Home-manager modules
            kitty
          ];
        };
      };
    }
    ```

4.  **Build Your Host**:
    Once you've created the `default.nix`, you can build your new host configuration:

    ```bash
    sudo nixos-rebuild switch --flake .#my-new-host
    ```

This structure allows you to keep your host-specific configurations isolated while re-using the modules defined in the rest of the flake.

---

## Packages

Standalone packages can be run directly without installing them system-wide.

| Package  | Description                  |
| -------- | ---------------------------- |
| `neovim` | Neovim configured via nixvim |

```bash
# Run directly
nix run .#neovim

# Run from anywhere using the flake URL
nix run github:matthiasbenaets/nixos-config#neovim

# Add temporarily to PATH
nix shell .#neovim
```

---

## Dev Shells

Pre-configured development environments with all relevant tools available.

| Shell     | Tools                                        |
| --------- | -------------------------------------------- |
| `default` | `vim`, `git`                                 |
| `neovim`  | Configured neovim + `git`                    |
| `python`  | Python tooling                               |
| `nodejs`  | `nodejs`, `npm` with local prefix configured |

```bash
# Enter a shell
nix develop .#<shell>

# Examples
nix develop .#nodejs
nix develop .#python
nix develop            # enters default shell
```

> **Note:** Dev shells use `nix develop`. `nix run` and `nix shell` are for packages, not dev shells.

---

## Maintenance

### Garbage Collection

Nix stores all packages in the `/nix/store`, and over time this can grow quite large. You can remove unused packages (garbage) to free up space.

To remove all packages that are not referenced by any user profile or configuration:

```bash
nix-store --gc
```

To see what would be deleted without actually deleting it:

```bash
nix-store --gc --print-dead
```

You can also free up more space by optimising the nix store:

```bash
nix-store --optimise
```

It's also possible to clean for the current user or system wide:

```bash
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

---

## Development Reference

### Evaluating Configurations

Use these commands to check if a configuration evaluates without errors:

```bash
nix eval <path/to/flake>#nixosConfigurations.<host>.config.system.build.toplevel --show-trace
nix eval <path/to/flake>#darwinConfigurations.<host>.config.system.build.toplevel --show-trace
nix eval <path/to/flake>#homeConfigurations.<host>.activationPackage --show-trace
nix eval <path/to/flake>#<package> --show-trace

```

### Updating Inputs

```bash
# Update all inputs
nix flake update

# Update a specific input
nix flake update nixpkgs

```

### Updating Channels

```bash
sudo nix-channel --list
sudo nix-channel --remove <name>
sudo nix-channel --add <channel url> <name>
sudo nix-channel --update
```

### Checking Flake Outputs

```bash
nix flake show
```
