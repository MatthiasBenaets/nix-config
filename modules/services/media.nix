#
# Media Services: Plex, Torrenting and automation
#

{ config, pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      radarr
      sonarr
      jackett
      bazarr
      handbrake
      deluge
    ];
  };

  services = {
    jackett = {
      enable = true;
    };
    radarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    sonarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    bazarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    deluge = {
      enable = true;
      web.enable = true;
      user = "root";
      group = "users";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      radarr = prev.radarr.overrideAttrs (old: rec {
        installPhase = ''
          runHook preInstall
          mkdir -p $out/{bin,share/${old.pname}-${old.version}}
          cp -r * $out/share/${old.pname}-${old.version}/.
          makeWrapper "${final.dotnet-runtime}/bin/dotnet" $out/bin/Radarr \
            --add-flags "$out/share/${old.pname}-${old.version}/Radarr.dll" \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
              final.curl final.sqlite final.libmediainfo final.mono final.openssl final.icu final.zlib ]}
          runHook postInstall
        '';
      });
    })
  ];
}

# literally can't be bothered anymore with user permissions.
# So everything with root, add permissions 775 with group users in radarr and sonar
# (Under Media Management - Show Advanced | Under Subtitles)
# Radarr & Sonarr: chmod 775
# Bazarr: chmod 664
# Deluge: 
#   Connection Manager: localhost:58846
#   Preferences: Change download folder and enable Plugins-label
