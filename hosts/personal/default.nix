{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Add personal-only packages, brews, casks, and aliases here.

  system.defaults.dock.persistent-apps = [
    "/Applications/Brave Browser.app"
    "/System/Applications/Messages.app"
    "/Applications/Spotify.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Notes.app"
    "/Applications/Claude.app"
    "/Applications/Gemini.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/iTerm.app"
    "/System/Applications/System Settings.app"
  ];
}
