{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment = {
        # variables = {
        #   TERMINAL = "${vars.terminal}";
        #   EDITOR = "${vars.editor}";
        #   VISUAL = "${vars.editor}";
        # };
        systemPackages = with pkgs; [
          # Terminal
          btop # Resource Manager
          cifs-utils # Samba
          coreutils # GNU Utilities
          gemini-cli-bin # AI
          git # Version Control
          jq # JSON Manipulation
          killall # Process Killer
          lshw # Hardware Config
          nano # Text Editor
          nodejs # Javascript Runtime
          nodePackages.pnpm # Package Manager
          nix-tree # Browse Nix Store
          pciutils # Manage PCI
          ranger # File Manager
          ripgrep # Recursive Search
          smartmontools # Disk Health
          tldr # Helper
          trash-cli # Recycle Bin
          usbutils # Manage USB
          wget # Retriever
          xdg-utils # Environment integration

          # Video/Audio
          feh # Image Viewer
          linux-firmware # Proprietary Hardware Blob
          mpv # Media Player
          vlc # Media Player

          # Apps
          appimage-run # Runs AppImages on NixOS
          firefox # Browser
          google-chrome # Browser
          remmina # XRDP & VNC Client

          # File Management
          file-roller # Archive Manager
          thunar # File Browser
          p7zip # Zip Encryption
          rsync # Syncer - $ rsync -r dir1/ dir2/
          unzip # Zip Files
          unrar # Rar Files
          stable.onlyoffice-desktopeditors # Office
          zip # Zip
          stable.image-roll # Image viewer
        ];
      };
    };
}
