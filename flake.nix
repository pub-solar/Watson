{
  description = "Watson devenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        args@{ pkgs, config, system, ... }: {
          packages = {
            watson-td = pkgs.python3Packages.buildPythonPackage {
              name = "watson-td";
              src = ./.;
              propagatedBuildInputs = with pkgs.python3Packages; [
                # requirements
                click
                click-didyoumean
                requests
                arrow

                # requirements-dev
                flake8
                py
                pytest
                pytest-datafiles
                pytest-mock
                pytest-runner
                pytest-runner
              ];
            };
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              gnumake
              virtualenv
              yaml-language-server
              (python3.withPackages (p: [
                # LSP support
                p.python-lsp-ruff
                p.python-lsp-server
                p.python-lsp-server.optional-dependencies

                # pip
                p.pip

                # requirements
                p.click
                p.click-didyoumean
                p.requests
                p.arrow

                # requirements-dev
                p.flake8
                p.py
                p.pytest
                p.pytest-datafiles
                p.pytest-mock
                p.pytest-runner
                p.pytest-runner
              ]))
            ];
          };
        };
    };
}
