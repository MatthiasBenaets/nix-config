#
#  Python development shell
#  Pip packages will be installed in the parent working directory and will be added to PATH and PYTHONPATH
#

{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    (pkgs.python3.withPackages (ps: [
      ps.pip
      ps.tkinter
    ]))
    python3Packages.python-lsp-server
    poetry # Instead of pip, you can use $ poetry init -n --name <name> and $ poetry add request <package> to install python packages
  ];
  shellHook = ''
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH
  '';
}
