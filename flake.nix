{
  description = "Watson devenv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {self, nixpkgs, systems, devshell }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      # Nixpkgs instantiated for system types in nix-systems
      nixpkgsFor = eachSystem (system:
        import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlays.default
          ];
        }
      );
    in
    {
      devShells = eachSystem (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.devshell.mkShell {
            # Add additional packages you'd like to be available in your devshell
            # PATH here
            devshell.packages = with pkgs; [
              gnumake
              virtualenv
              (pkgs.python3.withPackages (p: [
                # select Python packages here
                p.python-lsp-ruff
                p.python-lsp-server
                p.python-lsp-server.optional-dependencies
              ]))
            ];
          };
        });

      packages = eachSystem (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
        });
    };
}
