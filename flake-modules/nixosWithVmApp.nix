# 
{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.mizore.nixosConfigurationsWithVmApp;
in {
  options.mizore.nixosConfigurationsWithVmApp = lib.mkOption {
    default = {};
    description = "NixOS system configurations with corresponding VM apps.";
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        system = lib.mkOption {
          type = lib.types.str;
          description = "The system architecture for this configuration (e.g., x86_64-linux, aarch64-linux).";
        };
        module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The NixOS module to use for this system.";
        };
      };
    });
  };

  config = {
    flake.nixosConfigurations =
      lib.mapAttrs' (
        name: attrs: let
          nixosConfiguration = inputs.nixpkgs.lib.nixosSystem {
            system = attrs.system;
            modules = [attrs.module];
          };
        in
          lib.nameValuePair name nixosConfiguration
      )
      cfg;

    perSystem = {...}: {
      apps =
        lib.mapAttrs' (
          name: attrs: let
            nixosConfiguration = inputs.nixpkgs.lib.nixosSystem {
              system = attrs.system;
              modules = [
                attrs.module
                ({modulesPath, ...}: {
                  imports = [
                    (modulesPath + "/virtualisation/qemu-vm.nix")
                  ];
                })
              ];
            };
            nixos-hostname = nixosConfiguration.config.networking.hostName;
          in
            lib.nameValuePair "vm:${name}" {
              type = "app";
              program = "${nixosConfiguration.config.system.build.vm}/bin/run-${nixos-hostname}-vm";
            }
        )
        cfg;
    };
  };
}
