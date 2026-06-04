{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = [
    pkgs.oci-cli # Oracle Cloud Infrastructure CLI
    pkgs.python3Packages.argcomplete # Python package for command-line argument completion
    pkgs.azure-cli # Azure CLI for managing Azure resources
    pkgs.google-cloud-sdk # Includes gcloud and Gemini
  ];

  homebrew.brews = [
    "k6" # Load testing tool for developers and testers
    "exoscale/tap/exoscale-cli" # Exoscale CLI for managing Exoscale cloud resources
    "age" # File encryption tool
  ];

  homebrew.casks = [
    "claude" # Anthropic's AI assistant
    "claude-code" # AI coding assistant by Anthropic
    "google-gemini" # Google's AI assistant
    "raycast" # AI-powered productivity tool
  ];

  environment.shellAliases = {
    # Divio specific aliases
    lint = "docker run --rm -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint";
  };
}
