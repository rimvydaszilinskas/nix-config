{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = [
    pkgs.python3Packages.argcomplete # Python package for command-line argument completion
    pkgs.azure-cli # Azure CLI for managing Azure resources
    pkgs.google-cloud-sdk # Includes gcloud and Gemini
    pkgs.pipenv # Python dependency manager
  ];

  homebrew.brews = [
    "k6" # Load testing tool for developers and testers
    "exoscale/tap/exoscale-cli" # Exoscale CLI for managing Exoscale cloud resources
    "age" # File encryption tool
    "clowdhaus/taps/eksup" # EKS upgrade checker, alternative to kubent
    "tmux" # Terminal multiplexer
  ];

  homebrew.casks = [
    "raycast" # AI-powered productivity tool
    "notion" # Document collaboration tool
    "google-chrome"
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Brave Browser.app"
    "/Applications/Google Chrome.app"
    "/System/Applications/Messages.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Notes.app"
    "/Applications/Slack.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Claude.app"
    "/Applications/Gemini.app"
    "/Applications/iTerm.app"
    "/Applications/Spotify.app"
    "/Applications/1Password.app"
    "/Applications/Dashlane.app"
    "/Applications/Notion.app"
    "/System/Applications/System Settings.app"
  ];

  environment.shellAliases = {
    # Divio specific aliases
    lint = "docker run --rm -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint";
  };
}
