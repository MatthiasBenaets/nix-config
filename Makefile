# Matthias' Nix Configuration Flake — Makefile
# Usage: make <target>

SHELL := /usr/bin/env bash
FLAKE := .

# ── Help (grouped by platform) ────────────────────────────────────────────────

.PHONY: help
help: ## Show this help (grouped by platform)
	@echo "╭──────────────────────────────────────────────────────────────────────────────────────────────────╮"
	@echo "│  Matthias' Nix Config — Makefile Help                                                            │"
	@echo "╰──────────────────────────────────────────────────────────────────────────────────────────────────╯"
	@echo ""
	@echo "General:"
	@grep -E '^help:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "List & Info:"
	@grep -E '^(list|show):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "NixOS (Linux desktops):"
	@grep -E '^(nixos|nixos-build|nixos-eval):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "Darwin (macOS):"
	@grep -E '^(darwin|darwin-build|darwin-eval):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "Home Manager (standalone Linux):"
	@grep -E '^(home|home-build|home-eval):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "Dev Shells & Packages:"
	@grep -E '^(shell|develop|run):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "Maintenance & Update:"
	@grep -E '^(gc|gc-sudo|optimise|clean|update):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }'
	@echo ""
	@echo "╭─ Examples ───────────────────────────────────────────────────────────────────────────────────────╮"
	@echo "│  make nixos HOST=beelink                       # Rebuild NixOS desktop                           │"
	@echo "│  make nixos-build HOST=beelink                 # Build NixOS without applying                    │"
	@echo "│  make nixos-eval HOST=beelink                  # Check NixOS config for errors                   │"
	@echo "│  make darwin HOST=m1                           # Rebuild M1 MacBook                              │"
	@echo "│  make home HOST=ubuntu                         # Switch home-manager on generic Linux            │"
	@echo "│  make shell SHELL=nodejs                       # Shell with node.js package                      │"
	@echo "│  make develop SHELL=nodejs                     # Enter node.js dev environment                   │"
	@echo "│  make run PKG=neovim                           # Run neovim                                      │"
	@echo "│  make update                                   # Update all flake input                          │"
	@echo "│  make update CHANNEL=nixpkgs                   # Update specific flake input                     │"
	@echo "╰──────────────────────────────────────────────────────────────────────────────────────────────────╯"

# ── List / Info (dynamic) ──────────────────────────────────────────────────────

.PHONY: list
list: ## List all configured hosts, shells & packages (dynamic)
	@echo ""
	@colorize() { awk '{printf "  \033[36m%s\033[0m\n", $$0}'; }; \
	NIX_JSON=$$(nix flake show --json 2>/dev/null || echo '{}'); \
	echo "╭─ NixOS Hosts ──────────────────────────────────────────────────────────────────╮"; \
	echo "$$NIX_JSON" | jq -r '.nixosConfigurations | keys[]' 2>/dev/null \
		| colorize \
	|| for d in modules/hosts/nixos/*; do \
		[ -d "$$d" ] && basename "$$d"; \
	done | sort | colorize; \
	echo ""; \
	echo "╭─ Darwin (macOS) Hosts ─────────────────────────────────────────────────────────╮"; \
	if [ $$(echo "$$NIX_JSON" | jq '.darwinConfigurations | if . == {} or (. | keys | length == 1 and .[0] == "type") then 1 else 0 end') = "0" ]; then \
		echo "$$NIX_JSON" | jq -r '.darwinConfigurations | keys[]' 2>/dev/null | colorize; \
	else \
		for d in modules/hosts/darwin/*; do \
			[ -d "$$d" ] && basename "$$d"; \
		done | sort | colorize; \
	fi; \
	echo ""; \
	echo "╭─ Home Manager Hosts ───────────────────────────────────────────────────────────╮"; \
	if [ $$(echo "$$NIX_JSON" | jq '.homeConfigurations | if . == {} or (. | keys | length == 1 and .[0] == "type") then 1 else 0 end') = "0" ]; then \
		echo "$$NIX_JSON" | jq -r '.homeConfigurations | keys[]' 2>/dev/null | colorize; \
	else \
		for d in modules/hosts/nix/*; do \
			[ -d "$$d" ] && basename "$$d"; \
		done | sort | colorize; \
	fi; \
	echo ""; \
	echo "╭─ Dev Shells ───────────────────────────────────────────────────────────────────╮"; \
	echo "$$NIX_JSON" | jq -r '(first(.devShells | to_entries[] | select(.value | type == "object" and (. | keys | length > 0)))) as $$e | $$e.key as $$s | .devShells[$$s] | keys[]' 2>/dev/null | colorize; \
	echo ""; \
	echo "╭─ Packages ─────────────────────────────────────────────────────────────────────╮"; \
	echo "$$NIX_JSON" | jq -r '(first(.packages | to_entries[] | select(.value | type == "object" and (. | keys | length > 0)))) as $$e | $$e.key as $$s | .packages[$$s] | keys[]' 2>/dev/null | colorize; \
	echo ""

.PHONY: show
show: ## Show full flake tree (nix flake show)
	nix flake show $(FLAKE) --all-systems --refresh

# ── NixOS ──────────────────────────────────────────────────────────────────────

.PHONY: nixos
nixos: ## Rebuild a NixOS host — usage: make nixos HOST=beelink
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

.PHONY: nixos-build
nixos-build: ## Build a NixOS config without applying — usage: make nixos-build HOST=beelink
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	sudo nixos-rebuild build --flake $(FLAKE)#$(HOST)

# ── Darwin (macOS) ─────────────────────────────────────────────────────────────

.PHONY: darwin
darwin: ## Rebuild a Darwin host — usage: make darwin HOST=m1
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	darwin-rebuild switch --flake $(FLAKE)#$(HOST)

.PHONY: darwin-build
darwin-build: ## Build a Darwin config without applying — usage: make darwin-build HOST=m1
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	nix build $(FLAKE)#darwinConfigurations.$(HOST).system

# ── Home Manager (standalone Linux) ────────────────────────────────────────────

.PHONY: home
home: ## Switch standalone home-manager — usage: make home HOST=ubuntu
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	home-manager switch --flake $(FLAKE)#$(HOST)

.PHONY: home-build
home-build: ## Build a home-manager config without applying — usage: make home-build HOST=ubuntu
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	home-manager build --flake $(FLAKE)#$(HOST)

# ── Dev Shells ─────────────────────────────────────────────────────────────────

.PHONY: shell
shell: ## Shell a package — usage: make shell SHELL=nodejs
	@[ -n "$(SHELL)" ] || { echo "Error: SHELL= is required. Run 'make help'"; exit 1; }
	nix shell $(FLAKE)#$(SHELL)

.PHONY: develop
develop: ## Enter a dev shell — usage: make develop SHELL=nodejs
	@[ -n "$(SHELL)" ] || { echo "Error: SHELL= is required. Run 'make help'"; exit 1; }
	nix develop $(FLAKE)#$(SHELL)

# ── Packages ───────────────────────────────────────────────────────────────────

.PHONY: run
run: ## Run a package — usage: make run PKG=neovim
	@[ -n "$(PKG)" ] || { echo "Error: PKG= is required. Run 'make help'"; exit 1; }
	nix run $(FLAKE)#$(PKG)

# ── Maintenance ────────────────────────────────────────────────────────────────

.PHONY: gc
gc: ## Garbage collect (current user)
	nix-collect-garbage -d

.PHONY: gc-sudo
gc-sudo: ## Garbage collect (system-wide)
	sudo nix-collect-garbage -d

.PHONY: optimise
optimise: ## Optimise the Nix store (deduplicate)
	nix-store --optimise

.PHONY: clean
clean: gc optimise ## Garbage collect + optimise (free up disk space)

# ── Update ─────────────────────────────────────────────────────────────────────

.PHONY: update
update: ## Update all flake inputs, or a single one — usage: make update CHANNEL=nixpkgs
	nix flake update $(CHANNEL)

# ── Eval ─────────────────────────────────────────────────────────────────────────

.PHONY: nixos-eval
nixos-eval: ## Eval a NixOS config — usage: make nixos-eval HOST=beelink
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	nix eval $(FLAKE)#nixosConfigurations.$(HOST).config.system.build.toplevel --show-trace

.PHONY: darwin-eval
darwin-eval: ## Eval a Darwin config — usage: make darwin-eval HOST=intel
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	nix eval $(FLAKE)#darwinConfigurations.$(HOST).config.system.build.toplevel --show-trace

.PHONY: home-eval
home-eval: ## Eval a home-manager config — usage: make home-eval HOST=ubuntu
	@[ -n "$(HOST)" ] || { echo "Error: HOST= is required. Run 'make help'"; exit 1; }
	nix eval $(FLAKE)#homeConfigurations.$(HOST).activationPackage --show-trace
