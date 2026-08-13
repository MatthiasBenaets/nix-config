{
  config,
  pkgs,
  ...
}:

{
  packages = [
    pkgs.pandoc
    config.packages.pandoc
    config.packages.tex
    config.packages.mermaid-filter-nix
  ];

  shellHook = ''
    # export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    export MERMAID_FILTER_FORMAT="png"
    export MERMAID_FILTER_SCALE="4"
    echo "Pandoc environment loaded!"
    echo "Run 'build <filename.md>' to compile your document."
  '';
}
