{
  description = "Shared Nix Shell Environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, rust-overlay, flake-utils, ... }:
    let
      systems = flake-utils.lib.eachDefaultSystem (system:
        let
          overlays = [ (import rust-overlay) ];
          # Default pkgs
          pkgs = import nixpkgs {
            system = system;
            overlays = overlays;
          };

          # Unstable packages
          pkgsUnstable = import nixpkgs-unstable {
            system = system;
            overlays = overlays;
          };

          # Unfree-enabled pkgs
          pkgsUnfree = import nixpkgs {
            system = system;
            overlays = overlays;
            config = { allowUnfree = true; };
          };

        in {
          devShells = {
            default = import ./shell.nix { inherit pkgs; };

            # go
            go = import ./shells/go/stable.nix { inherit pkgs; };
            go-stable = import ./shells/go/stable.nix { inherit pkgs; };

            # java
            java = import ./shells/java/jdk23.nix { inherit pkgs; };
            java-23 = import ./shells/java/jdk23.nix { inherit pkgs; };
            java-21 = import ./shells/java/jdk21.nix { inherit pkgs; };
            java-17 = import ./shells/java/jdk17.nix { inherit pkgs; };
            java-11 = import ./shells/java/jdk11.nix { inherit pkgs; };

            # javascript
            nodejs = import ./shells/javascript/nodejs-22.nix { inherit pkgs; };
            nodejs-23 =
              import ./shells/javascript/nodejs-23.nix { inherit pkgs; };
            nodejs-22 =
              import ./shells/javascript/nodejs-22.nix { inherit pkgs; };
            nodejs-20 =
              import ./shells/javascript/nodejs-20.nix { inherit pkgs; };
            nodejs-18 =
              import ./shells/javascript/nodejs-18.nix { inherit pkgs; };

            # python
            python = import ./shells/python/python-312.nix { inherit pkgs; };
            python-313 =
              import ./shells/python/python-313.nix { inherit pkgs; };
            python-venv =
              import ./shells/python/python-312-venv.nix { inherit pkgs; };
            python-313-venv =
              import ./shells/python/python-313-venv.nix { inherit pkgs; };
            python-312 =
              import ./shells/python/python-312.nix { inherit pkgs; };
            python-312-venv =
              import ./shells/python/python-312-venv.nix { inherit pkgs; };
            python-311 =
              import ./shells/python/python-311.nix { inherit pkgs; };
            python-311-venv =
              import ./shells/python/python-311-venv.nix { inherit pkgs; };
            python-310 =
              import ./shells/python/python-310.nix { inherit pkgs; };
            python-310-venv =
              import ./shells/python/python-310-venv.nix { inherit pkgs; };

            # rust
            rust = import ./shells/rust/stable.nix { inherit pkgs; };
            rust-stable = import ./shells/rust/stable.nix { inherit pkgs; };
            rust-beta = import ./shells/rust/beta.nix { inherit pkgs; };

            # terraform
            terraform =
              import ./shells/terraform/default.nix { inherit pkgsUnfree; };
            terraform-lsp =
              import ./shells/terraform/lsp.nix { inherit pkgsUnfree; };

          };
        });
    in {
      inherit (systems) devShells;

      templates = {
        shell = {
          path = ./templates/shell;
          description = "Shell simple flake";
        };
        python = {
          path = ./templates/python/simple;
          description = "Python simple flake";
        };
        python-shell = {
          path = ./templates/python/shell;
          description = "Python shell & flake";
        };
      };
      defaultTemplate = self.templates.shell;
    };

}

