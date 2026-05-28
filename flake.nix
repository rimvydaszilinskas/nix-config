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
            pkgs.azure-cli
            pkgs.google-cloud-sdk # Includes gcloud and Gemini
          ];

          homebrew = {
            enable = true;
            onActivation.cleanup = "uninstall";
            onActivation.autoUpdate = true;

            # FIXED: "brews" instead of "brew" is correct for nix-darwin,
            # but usually it's plural. You had "brews" which is correct.
            brews = [
              "mas" # Macbooks Apps Store
              # Development tools
              "awscli" # AWS CLI
              "gh" # GitHub CLI
              "kubernetes-cli" # kubectl
              "tfenv" # Terraform version manager
              "fzf" # Fuzzy finder for command line
              "k9s" # Kubernetes dashboard CLI
              "speedtest-cli" # Internet speed test CLI
              "opencode" # Open source coding assistant
              "thefuck" # Command line tool to correct previous console commands
              "gnupg" # GPG for encryption/signing
              "pinentry-mac" # GPG pinentry for macOS
              "go-task/tap/go-task"
            ];
            casks = [
              "visual-studio-code"
              "iterm2"
              "font-meslo-lg-nerd-font"

              # AI tools
              "claude"
              "google-gemini"
              "raycast"

              # Browsers
              "vivaldi"
              "brave-browser"

              # Password managers
              "1password"
              "1password-cli"

              "slack"
              "spotify"
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
            tilesize = 40;
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
        # FIXED: Passed 'inputs' through to modules if needed
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
