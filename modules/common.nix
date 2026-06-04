{ pkgs, self, username, homeDirectory, ... }:
{
  nix.enable = false;
  programs.zsh.enable = true;

  users.users.${username}.home = homeDirectory;
  system.primaryUser = username;

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
    pkgs.ollama # Ollama CLI for running local LLMs
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.extraFlags = [ "--force" ];
    onActivation.autoUpdate = true;

    brews = [
      "mas" # Mac App Store CLI
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
      "pre-commit" # A framework for managing and maintaining multi-language pre-commit hooks
    ];

    casks = [
      "visual-studio-code" # VSCode
      "iterm2" # Terminal replacement
      "font-meslo-lg-nerd-font" # Font for terminal and code editor
      "orbstack" # Docker alternative for macOS
      "terraform-linters/tap/tflint" # Terraform linter

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
    username
  ];

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
