# Mizore

## Usage
```nix
{
  inputs = {
    flake-parts.url = "github:numtide/flake-parts";
    mizore.url = "github:comavius/mizore";
    # ...
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [ inputs.mizore.flakeModules.default ];
      # ...
    }
}
```

## Features
### `mizore.nixosWithVmApp`
```nix
{inputs, ...}: {
    mizore.nixosWithVmApp.myNixos = {
        system = "x86_64-linux";
        module = # your nixos module here
    }
}
```

```bash
sudo nixos-rebuild switch --flake ".#myNixos"
```

or

```bash
nix run ".#vm:myNixos"
```