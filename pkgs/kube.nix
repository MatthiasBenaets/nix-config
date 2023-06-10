{ pkgs, ... }:
with pkgs;
{
  home = {
    packages = with pkgs; [
      # all the kubernetes related stuff
      argo argocd colima kubectx kubectl go_1_20 kustomize
      helmfile kubernetes-helm k9s krew crane minikube kind octant awscli2 vault terraform cosign docker-client syft grype ko cmctl 
    ];
  };
}
