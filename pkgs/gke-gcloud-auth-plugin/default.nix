{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gke-gcloud-auth-plugin";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "cloud-provider-gcp";
    rev = "auth-provider-gcp/v${version}";
    hash = "sha256-ztLuve6B6YyMjyJwqwJqyickmzFwP/wJtdMkGFn3hmg=";
  };

  vendorSha256 = null;
  subPackages = [ "cmd/gke-gcloud-auth-plugin" ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes/cloud-provider-gcp";
    description = "";
    license = licenses.asl20;
  };
}
