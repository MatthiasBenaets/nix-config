{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    nodejs
    npm
  ];

  shellHook = ''
    npm set prefix ~/.npm-global
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo "done"
  '';
}
