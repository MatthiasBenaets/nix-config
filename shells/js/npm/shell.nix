#
# When installing packages globally using "$ npm install -g <package>"
# the binary will be installed in $HOME/.npm-global and should be available in your PATH
#

with import <nixpkgs> { };
mkShell {
  name = "NPM-Shell";
  buildInputs = with pkgs; [
    nodejs
    nodePackages.npm
  ];

  shellHook = ''
    npm set prefix ~/.npm-global
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo "done"
  '';
}
