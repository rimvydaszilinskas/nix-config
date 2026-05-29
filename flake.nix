{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nix.enable = false;
          programs.zsh.enable = true;

          users.users.rim.home = "/Users/rim";
          system.primaryUser = "rim";

          environment.systemPackages = [
            pkgs.vim
            pkgs.neovim
            pkgs.git
            pkgs.ripgrep
            pkgs.nixfmt
            pkgs.bat
            pkgs.eza
            pkgs.bottom
            pkgs.zoxide
            pkgs.uv
            pkgs.direnv
            pkgs.pipenv
            pkgs.atuin
            pkgs.rustup
            pkgs.go
            pkgs.hugo
            pkgs.oci-cli
            pkgs.python3Packages.argcomplete
            pkgs.azure-cli
            pkgs.google-cloud-sdk # Includes gcloud and Gemini
          ];

          homebrew = {
            enable = true;
            onActivation.cleanup = "uninstall";
            onActivation.autoUpdate = true;

            brews = [
              "mas" # Macbooks Apps Store
              # Development tools
              "awscli" # AWS CLI
              "gh" # GitHub CLI
              "glab" # GitLab CLI
              "kubernetes-cli" # kubectl
              "helm" # Kubernetes package manager
              "krew" # kubectl plugin manager
              "tfenv" # Terraform version manager
              "fzf" # Fuzzy finder for command line
              "k9s" # Kubernetes dashboard CLI
              "speedtest-cli" # Internet speed test CLI
              "opencode" # Open source coding assistant
              "thefuck" # Command line tool to correct previous console commands
              "gnupg" # GPG for encryption/signing
              "pinentry-mac" # GPG pinentry for macOS
              "go-task/tap/go-task" # Taskfile runner
              "dashlane/tap/dashlane-cli" # Dashlane CLI for password management
              "tmux" # Terminal multiplexer
              "lazygit" # Terminal UI for git commands
              "lazydocker" # Terminal UI for Docker management
              "jq" # Command-line JSON processor
              "yq" # Command-line YAML processor
              "kubectx" # kubectl context switcher
              "just" # Command runner similar to Makefile but simpler
              "pre-commit" # A framework for managing and maintaining multi-language pre-commit hooks."
            ];
            casks = [
              "visual-studio-code" # VSCode
              "iterm2" # Terminal replacement 
              "font-meslo-lg-nerd-font" # Font for terminal and code editor
              "orbstack" # Docker alternative for macOS
              "terraform-linters/tap/tflint" # Terraform linter

              # AI tools
              "claude"
              "google-gemini"
              "raycast"

              # Browsers
              "brave-browser"

              # Password managers
              "1password"
              "1password-cli"

              "slack"
              "notion"

              "spotify"

              "loop" # Mac tiling window manager
              "stats" # System monitoring tool for macOS in the menu bar
              "hiddenbar" # Menu bar app to hide icons and manage space

              "logi-options+" # Logitech mouse and keyboard configuration software
            ];

            masApps = {
              "Dashlane" = 517914548;
            };
          };

          environment.shellAliases = {
            nix-rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin";
            tf = "terraform";
            k = "kubectl";
          };

          system.defaults.dock = {
            autohide = true;
            tilesize = 30;
            magnification = true;
            largesize = 50;
            minimize-to-application = false;
          };

          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "rim"
          ];

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      darwinConfigurations."Rimvydass-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rim = import ./home.nix;
          }
        ];
      };
    };
}
