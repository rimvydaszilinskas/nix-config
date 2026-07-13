{
  pkgs,
  self,
  username,
  homeDirectory,
  ...
}:
{
  # Disable the nix module provided by nix-darwin — nix itself is managed externally (e.g. Determinate Nix)
  nix.enable = false;

  # Enable zsh system-wide so it appears in /etc/shells and is usable as a login shell
  programs.zsh.enable = true;

  # Bind the declared username to a home directory and designate it as the primary GUI user
  users.users.${username}.home = homeDirectory;
  system.primaryUser = username;

  # ── Nix settings ─────────────────────────────────────────────────────────────

  nix.settings = {
    # Enable the unified CLI ("nix build", "nix run", etc.) and flakes
    experimental-features = "nix-command flakes";
    # Users that may add trusted binary caches and build with --option
    trusted-users = [
      "root"
      username
    ];
  };

  # ── System packages ───────────────────────────────────────────────────────────
  # Packages installed into /run/current-system/sw and available to every user.
  # Prefer Homebrew brews/casks for GUI apps and anything that ships its own updater.

  environment.systemPackages = [
    pkgs.vim # Terminal-based text editor, essential for quick edits and remote work
    pkgs.neovim # Modern Vim fork with better defaults and plugin ecosystem
    pkgs.git # Version control system
    pkgs.ripgrep # Fast search tool
    pkgs.nixfmt # Nix expression formatter
    pkgs.bat # cat clone with syntax highlighting and Git integration
    pkgs.eza # Modern ls alternative with git integration and better UI
    pkgs.bottom # Alternative to top with more features and better UI
    pkgs.zoxide # Fast directory jumper that learns your habits
    pkgs.uv # Fast Python package manager
    pkgs.direnv # Per-project environment variable loader (.envrc)
    pkgs.atuin # Shell history replacement with search and optional sync
    pkgs.rustup # Rust toolchain installer and version manager
    pkgs.go # Go programming language toolchain
    pkgs.hugo # Static site generator
    pkgs.ollama # CLI for running local LLMs
    pkgs.oci-cli # Oracle Cloud Infrastructure CLI
    # pkgs.tailscale # VPN service for secure remote access
  ];

  # ── Homebrew ──────────────────────────────────────────────────────────────────
  # Homebrew is used for packages not in nixpkgs or that need macOS-native builds.
  # onActivation.cleanup = "uninstall" removes any formula/cask not listed here.

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall"; # Remove packages no longer listed here on each rebuild
      autoUpdate = true; # Run `brew update` before installing
      upgrade = true; # Upgrade outdated packages before installing
      extraFlags = [ "--force" ]; # Pass --force to brew upgrade/install
    };

    brews = [
      "mas" # Mac App Store CLI — install and update App Store apps from the terminal

      # ── Cloud & infrastructure ──────────────────────────────────────────────
      "awscli" # AWS CLI v2 — interact with AWS services
      "tfenv" # Terraform version manager
      "terragrunt" # DRY Terraform wrapper for multi-environment deployments

      # ── Kubernetes ──────────────────────────────────────────────────────────
      "kubernetes-cli" # kubectl — standard Kubernetes CLI
      "helm" # Kubernetes package manager
      "helmfile" # Declarative spec for deploying Helm charts
      "krew" # kubectl plugin manager
      "k9s" # Full-screen terminal dashboard for Kubernetes clusters
      "kubectx" # Fast context and namespace switcher for kubectl

      # ── Source control / code review ────────────────────────────────────────
      "gh" # GitHub CLI — PRs, issues, workflows from the terminal
      "glab" # GitLab CLI — equivalent of gh for GitLab
      "lazygit" # Terminal UI for git — stage, commit, diff, rebase interactively
      "pre-commit" # Framework for managing and running multi-language pre-commit hooks

      # ── Productivity & shell utilities ───────────────────────────────────────
      "fzf" # Fuzzy finder — used by many plugins for interactive selection
      "jq" # Command-line JSON processor and pretty-printer
      "yq" # YAML/TOML/XML processor, same syntax as jq
      "just" # Simple command runner (Makefile alternative)
      "go-task/tap/go-task" # Task runner using Taskfile.yml
      "thefuck" # Corrects the previous console command when you type `fuck`
      "speedtest-cli" # Measure internet upload/download speed from the terminal
      "watch" # Utility for running a command repeatedly and showing the output
      "nmap" # Network scanning tool

      # ── Security & secrets ───────────────────────────────────────────────────
      "gnupg" # GnuPG — encrypt, sign, and verify files and communications
      "pinentry-mac" # GUI pinentry dialog so GPG can prompt for passphrase on macOS

      # ── Containers ───────────────────────────────────────────────────────────
      "lazydocker" # Terminal UI for Docker — manage containers, images, logs

      # ── Password management ───────────────────────────────────────────────────
      "dashlane/tap/dashlane-cli" # Dashlane CLI — fetch secrets and credentials
    ];

    casks = [
      # ── Development ───────────────────────────────────────────────────────────
      "visual-studio-code" # Primary code editor
      "iterm2" # Feature-rich terminal emulator
      "orbstack" # Lightweight Docker & Linux VM runtime for macOS
      "terraform-linters/tap/tflint" # Terraform linter with provider-specific rules
      "font-meslo-lg-nerd-font" # Patched Meslo font with icons for Powerline/Nerd prompts

      # ── Browsers ─────────────────────────────────────────────────────────────
      "brave-browser" # Privacy-first browser based on Chromium

      # ── Security ─────────────────────────────────────────────────────────────
      "1password" # Password manager (GUI app)
      "1password-cli" # 1Password CLI — inject secrets into scripts and env vars

      # ── AI ───────────────────────────────────────────────────────────────────
      "google-gemini" # Google's AI assistant desktop app

      # ── Communication ─────────────────────────────────────────────────────────
      "slack" # Team messaging

      # ── Media ────────────────────────────────────────────────────────────────
      "spotify" # Music streaming

      # ── macOS window & UI management ──────────────────────────────────────────
      "loop" # Keyboard-driven tiling window manager
      "stats" # System stats (CPU, RAM, network) in the menu bar
      "hiddenbar" # Collapse seldom-used menu bar icons into a hidden area

      # ── Peripherals ───────────────────────────────────────────────────────────
      "logi-options+" # Configure Logitech mice and keyboards (remapping, gestures)
    ];

    masApps = {
      "Dashlane" = 517914548;
      "Tailscale" = 1475387142;
    };
  };

  # ── Shell aliases ─────────────────────────────────────────────────────────────

  environment.shellAliases = {
    nix-rebuild = "~/.config/nix-darwin/scripts/nix-rebuild-trusted.sh";
    tf = "terraform";
    tg = "terragrunt";
    k = "kubectl";
  };

  # ── Security ─────────────────────────────────────────────────────────────────

  security.pam.services.sudo_local = {
    # Allow Touch ID to authenticate `sudo` in terminal sessions
    touchIdAuth = true;
  };

  # ── macOS system defaults ─────────────────────────────────────────────────────
  # All settings below are written to macOS defaults domains via `defaults write`.
  # Run `darwin-rebuild switch` to apply; most take effect immediately.

  system.defaults.dock = {
    autohide = true; # Hide the dock when not in use
    tilesize = 30; # Icon size in pixels (16–128)
    magnification = true; # Enlarge icons on hover
    largesize = 50; # Magnified icon size in pixels
    minimize-to-application = false; # Minimise windows into their app icon
    show-recents = true; # Don't show recently opened apps in the dock
    mru-spaces = false; # Don't reorder spaces based on most recent use
    orientation = "bottom"; # Dock position: "left", "bottom", or "right"
    show-process-indicators = true; # Show a dot under running applications
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true; # Show all file extensions
    AppleShowAllFiles = true; # Show hidden files (dotfiles)
    ShowPathbar = true; # Show breadcrumb path bar at the bottom
    ShowStatusBar = true; # Show item count / disk space bar at the bottom
    FXPreferredViewStyle = "Nlsv"; # Default view: "icnv" icon, "Nlsv" list, "clmv" column, "Flwv" gallery
    FXDefaultSearchScope = "SCcf"; # Search current folder by default ("SCev" = This Mac)
    QuitMenuItem = true; # Add Quit option to Finder menu (Cmd+Q)
    _FXShowPosixPathInTitle = true; # Show full POSIX path in the window title bar
    FXEnableExtensionChangeWarning = false; # Don't warn when changing a file extension
    NewWindowTarget = "Home"; # New Finder window opens at home directory
  };

  system.defaults.CustomUserPreferences."com.apple.finder" = {
    CalculateAllSizes = true; # Show folder sizes in list view
  };

  system.defaults.NSGlobalDomain = {
    # ── Autocorrect / text substitution ──────────────────────────────────────
    NSAutomaticCapitalizationEnabled = false; # No auto-capitalisation
    NSAutomaticDashSubstitutionEnabled = false; # No smart dashes (-- → —)
    NSAutomaticQuoteSubstitutionEnabled = false; # No smart quotes (" → ")
    NSAutomaticSpellingCorrectionEnabled = false; # No auto spell-correct

    # ── Keyboard ──────────────────────────────────────────────────────────────
    # Lower = faster. macOS default: KeyRepeat = 6, InitialKeyRepeat = 25
    ApplePressAndHoldEnabled = false; # Disable accent picker; allow key repeat instead
    KeyRepeat = 2; # Key repeat interval (2 = ~30 ms)
    InitialKeyRepeat = 15; # Delay before repeat starts (15 = ~225 ms)

    # ── UI & appearance ───────────────────────────────────────────────────────
    AppleInterfaceStyle = "Dark"; # "Dark" or remove key for Light mode
    AppleShowScrollBars = "Automatic"; # "WhenScrolling", "Automatic", or "Always"
    NSDocumentSaveNewDocumentsToCloud = false; # Default save location = disk, not iCloud
    AppleICUForce24HourTime = true; # Use 24-hour clock regardless of locale

    # ── Window behaviour ──────────────────────────────────────────────────────
    NSWindowShouldDragOnGesture = true; # Drag windows by clicking anywhere on the title bar
  };

  system.defaults.trackpad = {
    Clicking = true; # Tap-to-click (no physical press needed)
    TrackpadThreeFingerDrag = false; # Three-finger drag to move windows
    TrackpadRightClick = true; # Two-finger tap = right-click
  };

  system.defaults.screencapture = {
    location = "~/Desktop/Screenshots"; # Where screenshots are saved
    type = "png"; # Screenshot format: "png", "jpg", "pdf", "gif", "tiff"
    disable-shadow = true; # Remove window drop-shadow from screenshots
  };

  system.defaults.screensaver = {
    askForPassword = false; # Don't require password after screensaver
    askForPasswordDelay = 0; # Delay in seconds before password is required (0 = immediately)
  };

  system.defaults.loginwindow = {
    GuestEnabled = false; # Disable the guest account on the login screen
  };

  system.defaults.ActivityMonitor = {
    IconType = 5; # Dock icon style: 0 = app icon, 5 = CPU history graph
    ShowCategory = 100; # 100 = All Processes, 102 = My Processes, 107 = Windowed Processes
    SortColumn = "CPUUsage"; # Sort processes by this column on launch
    SortDirection = 0; # 0 = descending, 1 = ascending
  };

  # ── Services ─────────────────────────────────────────────────────────────────
  # Enable and configure macOS services (daemons and agents) via launchd.
  # services.tailscale = {
  #   enable = true;
  # };

  # ── Login agents ─────────────────────────────────────────────────────────────
  # Launch GUI apps at login via launchd user agents.

  launchd.user.agents = {
    loop = {
      serviceConfig = {
        ProgramArguments = [ "/Applications/Loop.app/Contents/MacOS/Loop" ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };
    stats = {
      serviceConfig = {
        ProgramArguments = [ "/Applications/Stats.app/Contents/MacOS/Stats" ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };
  };

  # ── Versioning ────────────────────────────────────────────────────────────────
  # Pins the configuration to the current flake revision for auditability.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # Tracks the nix-darwin state schema version — increment only when instructed by nix-darwin release notes.
  system.stateVersion = 6;
}
