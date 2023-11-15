{ pkgs, lib, user, system, ... }:
let
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    '';
  });
in
{
  imports = [
    (import ../../modules/desktop/hyprland/default.nix)
  ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.users.chaosinthecrd = {
    isNormalUser = true;
    home = "/home/chaosinthecrd";
    extraGroups = [ "libvirt" "qemu-libvirtd" "kvm" "libvirtd" "audio" "disk" "video" "networkmanger" "docker" "wheel" ];
    shell = pkgs.zsh;
    group = "users";
    uid = 1027;
  };

  nixpkgs.overlays = [
  (self: super: {
    waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  })
  ];

  # Enable automatic login for the user.
  services.getty.autologinUser = "chaosinthecrd";

  services.flatpak.enable = true;

  services.blueman.enable = true;

  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     killall
     bash
     neovim
     kitty
     firefox
     gnupg1
     usbutils
     waybar
     swww
     gtk3
     gtk4
     nwg-look
     bibata-cursors
     pinentry-curses
     steam
     lutris
     wine
     wineWowPackages.waylandFull
     winetricks
     virtmanager
     looking-glass-client
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
        };
        verbatimConfig = ''
          namespaces = []
          user = "+1027"
        '';
      };
    onBoot = "ignore";
    onShutdown = "shutdown";
    extraConfig = ''
      user="chaosinthecrd"
    '';
  };

  programs.dconf.enable = true;

  hardware.xone.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
  };

  environment.sessionVariables = {
     WLR_NO_HARDWARE_CURSORS = "1";
     EDITOR="nvim";
     NIXOS_OZONE_WL = "1";
  };


  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
	      user = "chaosinthecrd";
    };
    default_session = initial_session;
  };
 };

  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  services.xremap = {
    userName = "chaosinthecrd";  # run as a systemd service in alice
    serviceMode = "user";  # run xremap as user
    withWlroots = true;
    config = {
      keymap = [
        {
            name = "Global";
            application = {
            not = [ "kitty" ];
            };
            remap = { "Super-v" = "C-v"; "Super-z" = "C-z"; "Super-c" = "C-c"; "Super-a" = "C-a"; "Super-x" = "C-x"; "Super-f" = "C-f"; "Super-t" = "C-t"; "Super-w" = "C-w";
                      "Alt-left" = "Ctrl-left"; "Alt-right" = "Ctrl-right"; "Alt-backspace" = "Ctrl-backspace";
                      "Super-g" = "C-g"; 
                        # not sure how this is gonna work yet "Super-=" = "C-="; "Super--" = "C--";
                    };  # globally remap CapsLock to Esc
        }
      ];
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
