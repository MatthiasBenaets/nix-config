{ ... }:
let
  tex =
    pkgs:
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium
        framed
        ;
    };

  mermaidFilter =
    pkgs:
    pkgs.buildNpmPackage rec {
      pname = "mermaid-filter";
      version = "1.4.7";
      src = pkgs.fetchFromGitHub {
        owner = "raghur";
        repo = "mermaid-filter";
        rev = "v${version}";
        hash = "sha256-GG2RWr5nVe6PCcTEJLmPyKL2j7ggSyNnHZAffNvPukg=";
      };
      npmDepsHash = "sha256-Hj4h8xTch2Z3ByUhxzPhbCTSXNOXuTXC6XUrBkRvQ/U=";
      dontNpmBuild = true;
      PUPPETEER_SKIP_DOWNLOAD = "1";
    };

  buildScript =
    pkgs:
    pkgs.writeShellScriptBin "build" ''
      if [ -z "$1" ]; then
        echo "Please provide a markdown file path."
        echo "Usage: build document.md"
        exit 1
      fi
      input_file="$1"
      output_file="''${input_file%.*}.pdf"
      echo "Compiling $input_file to $output_file..."
      pandoc "$input_file" -F mermaid-filter -o "$output_file"
    '';

  pandocEnvironment = {
    home.sessionVariables = {
      MERMAID_FILTER_FORMAT = "png";
      MERMAID_FILTER_SCALE = "4";
    };
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        tex = tex pkgs;
        mermaid-filter-nix = mermaidFilter pkgs;
        pandoc = buildScript pkgs;
      };
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.pandoc
          (mermaidFilter pkgs)
          (tex pkgs)
          (buildScript pkgs)
        ];
        shellHook = ''
          # export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
          export MERMAID_FILTER_FORMAT="png"
          export MERMAID_FILTER_SCALE="4"
          echo "Pandoc environment loaded!"
          echo "Run 'build <filename.md>' to compile your document."
        '';
      };
    };

  flake.modules.nixos.pandoc =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pandoc
        (mermaidFilter pkgs)
        (tex pkgs)
        (buildScript pkgs)
      ];
      home-manager.users.${config.host.user.name} = {
        imports = [ pandocEnvironment ];
      };
    };

  flake.modules.darwin.pandoc =
    { config, pkgs, ... }:
    {
      environment = {
        systemPackages = [
          pkgs.pandoc
          (mermaidFilter pkgs)
          (tex pkgs)
          (buildScript pkgs)
        ];
        variables.PUPPETEER_EXECUTABLE_PATH = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
      };
      home-manager.users.${config.host.user.name} = {
        imports = [ pandocEnvironment ];
      };
    };
}
