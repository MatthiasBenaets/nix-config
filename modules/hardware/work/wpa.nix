{
  flake.modules.nixos.work =
    { pkgs, ... }:
    let
      eduroamPatch = pkgs.writeText "eduroam.patch" ''
        --- a/src/crypto/tls_openssl.c
        +++ b/src/crypto/tls_openssl.c
        @@ -1048,7 +1048,7 @@

         	SSL_CTX_set_options(ssl, SSL_OP_NO_SSLv2);
         	SSL_CTX_set_options(ssl, SSL_OP_NO_SSLv3);
        -
        +	SSL_CTX_set_options(ssl, SSL_OP_LEGACY_SERVER_CONNECT);
         	SSL_CTX_set_mode(ssl, SSL_MODE_AUTO_RETRY);

         #ifdef SSL_MODE_NO_AUTO_CHAIN
      '';
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          wpa_supplicant = prev.wpa_supplicant.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ eduroamPatch ];
          });
        })
      ];
    };
}
