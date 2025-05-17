{
  description = "IaC Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        pkgsUnfree = import nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
        };
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgsUnfree; [terraform tfsec tflint terraform-ls];
          };
        };
      };
    };
}
