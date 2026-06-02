# Nix configuration for Mac

Nix configuration that consolidates Mac management in a declarative way.

## Pre-requisites

To make use of the repository the following are required:
- Nix Package Manager 
    ```sh
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```
- Brew
    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

## Initial run

Before the first run, there are no aliases and no configuration yet installed, run the initialization command first:

```
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```

Now the system is configured

## Applying changes

Every time an update happens you need to run the following command:

```
darwin-rebuild switch --flake ~/.config/nix-darwin
```

There is also an alias added to make it easier:

```
nix-rebuild
```
