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
            pkgs.vim # Terminal-based text editor, essential for quick edits and remote work
            pkgs.neovim # Modern Vim fork with better defaults and plugin ecosystem
            pkgs.git # Version control system
            pkgs.ripgrep # Fast search tool
            pkgs.nixfmt # Nix expression formatter
            pkgs.bat # A cat clone with syntax highlighting and Git integration
            pkgs.eza # Modern ls alternative with git integration and better UI
            pkgs.bottom # Alternative to top with more features and better UI
            pkgs.zoxide # Fast directory jumper
            pkgs.uv # Python package manager
            pkgs.direnv # Environment switcher for project directories
            pkgs.pipenv # Python dependency manager
            pkgs.atuin # Shell history replacement with search and sync capabilities
            pkgs.rustup # Rust toolchain installer and version manager
            pkgs.go # Go programming language
            pkgs.hugo # Static site generator
            pkgs.oci-cli # Oracle Cloud Infrastructure CLI
            pkgs.python3Packages.argcomplete # Python package for command-line argument completion
            pkgs.azure-cli # Azure CLI for managing Azure resources
            pkgs.google-cloud-sdk # Includes gcloud and Gemini
            pkgs.ollama # Ollama CLI for running local LLMs
          ];

          homebrew = {
            enable = true;
            onActivation.cleanup = "uninstall";
            onActivation.extraFlags = [ "--force" ];
            onActivation.autoUpdate = true;

            brews = [
              "mas" # Macbooks Apps Store
              # Development tools
              "awscli" # AWS CLI
              "gh" # GitHub CLI
              "glab" # GitLab CLI
              "kubernetes-cli" # kubectl
              "clowdhaus/taps/eksup" # EKS upgrade checker, alternative to kubent
              "helm" # Kubernetes package manager
              "helmfile" # Declarative spec for deploying helm charts
              "krew" # kubectl plugin manager
              "tfenv" # Terraform version manager
              "terragrunt" # Terraform wrapper for running tasks
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
              "pre-commit" # A framework for managing and maintaining multi-language pre-commit hooks"
              "k6" # Load testing tool for developers and testers
              "exoscale/tap/exoscale-cli" # Exoscale CLI for managing Exoscale cloud resources
              "age" # File encryption tool
            ];
            casks = [
              "visual-studio-code" # VSCode
              "iterm2" # Terminal replacement 
              "font-meslo-lg-nerd-font" # Font for terminal and code editor
              "orbstack" # Docker alternative for macOS
              "terraform-linters/tap/tflint" # Terraform linter

              # AI tools
              "claude" # Anthropic's AI assistant
              "claude-code" # AI coding assistant by Anthropic
              "google-gemini" # Google's AI assistant
              "raycast" # AI-powered productivity tool

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
            tg = "terragrunt";
            k = "kubectl";

            # Divio specific aliases
            lint = "docker run --rm -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint";
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
