{
  pkgs,
  ...
}:
let
  python = pkgs.python3;

  nativeLibs = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    glib
  ];
in
{
  packages = [
    python
    python.pkgs.pip
    python.pkgs.virtualenv
    pkgs.cacert
  ]
  ++ nativeLibs;

  shellHook = ''
    set -e

    export VENV_DIR="$PWD/.venv"

    # Create venv
    if [ ! -d "$VENV_DIR" ]; then
      echo "Creating virtualenv at $VENV_DIR using ${python}/bin/python"
      ${python}/bin/python -m venv "$VENV_DIR"
    fi

    # Activate venv
    source "$VENV_DIR/bin/activate"

    # Set pip install to use the venv
    unset PYTHONPATH
    export PYTHONNOUSERSITE=1
    export PIP_REQUIRE_VIRTUALENV=true

    # Fix SSL certs to reach PyPI
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export NIX_SSL_CERT_FILE="$SSL_CERT_FILE"
    export PIP_CERT="$SSL_CERT_FILE"

    # Set system libraries
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath nativeLibs}:$LD_LIBRARY_PATH"

    # Bootstrap pip
    python -m pip install --upgrade pip setuptools wheel -q

    if ! python -c "import notebook" 2>/dev/null; then
      echo "Installing jupyter notebook + ipykernel into the venv..."
      python -m pip install jupyter notebook ipykernel -q
    fi

    # Register kernel that point to the venv's python
    KERNEL_NAME="venv-$(basename "$PWD")"
    python -m ipykernel install --sys-prefix \
      --name "$KERNEL_NAME" \
      --display-name "Python ($(python --version 2>&1))" >/dev/null

    # Print info
    echo ""
    echo "venv ready:  $VENV_DIR"
    echo "python:      $(python --version)"
    echo "pip:         $(python -m pip --version)"
    echo "kernel:      $KERNEL_NAME"
    echo ""

    # Start jupyter notebook
    jupyter notebook
  '';
}
