{ pkgs, ... }:
{
  home.stateVersion = "24.11"; # Match your current Nixpkgs release
  home.enableNixpkgsReleaseCheck = false;

  # Ensure the VS Code shell launcher is always available in PATH.
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Better history handling
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
    };

    # DevOps essentials: Git info in the shell
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "aws"
      ];
      theme = "";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # Custom keybindings (Optional but helpful)
    initContent = ''
      # Ensure Homebrew CLI tools are available in interactive shells.
      export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Bind up/down arrows to history search
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
    '';
  };

  home.file.".p10k.zsh".source = ./p10k.zsh;

  programs.starship = {
    enable = false;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Rimvydas Zilinskas";
      user.email = "rimvydas.zilinskas@yahoo.com";
      init.defaultBranch = "master";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "code --wait";
      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate --all";
      };

    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
