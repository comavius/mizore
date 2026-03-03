{
  flakeModule = { ... }: {
    imports = [ ./flake-modules/nixosWithVmApp.nix ];
  };
}