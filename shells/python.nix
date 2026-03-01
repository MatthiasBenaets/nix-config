{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    (pkgs.python3.withPackages (
      python-pkgs: with python-pkgs; [
        numpy
        pandas
        requests
      ]
    ))
  ];

  shellHook = ''
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH
  '';
}
