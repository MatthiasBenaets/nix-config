### None of this is currently in use at the moment. Got the auth plugin some other way

{ pkgs, ... }:
with pkgs;
{
  gke-gcloud-auth-plugin = callPackage ./gke-gcloud-auth-plugin {};
}
