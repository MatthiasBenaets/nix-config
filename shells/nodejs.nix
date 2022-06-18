with import <nixpkgs> {};
mkShell {
  name = "React-Electron-Shell";
  buildInputs = with pkgs; [
    nodePackages.create-react-app
    electron
    nodejs
    yarn

    fakeroot
    dpkg
    rpm

    patchelf
    binutils
  ];
  ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin/"; #NEEDED to not get errors on npm start

  shellHook = ''
    echo "done"
  '';
}

# ELECTRON
#$ npx create-electron-app <appname>
#$ npm start    #inside directory
#$ rs           #restart/reload
