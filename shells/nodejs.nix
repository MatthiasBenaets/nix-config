{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    nodejs
    nodePackages.npm
  ];

  shellHook = ''
    npm set prefix ~/.npm-global
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo "done"
  '';
}
