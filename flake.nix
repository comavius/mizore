{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      flake.flakeModules = {
        default = import ./flake-module.nix;
        nixosWithVmApp = import ./flake-modules/nixosWithVmApp.nix;
      };
    };
}
