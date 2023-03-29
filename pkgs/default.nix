{ pkgs, ... }:
with pkgs;
{
  gke-gcloud-auth-plugin = callPackage ./gke-gcloud-auth-plugin {};
}
