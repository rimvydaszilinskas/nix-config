{ ... }:
{
  home.stateVersion = "24.11"; # Match your current Nixpkgs release
  home.enableNixpkgsReleaseCheck = false;

  # Ensure the VS Code shell launcher is always available in PATH.
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Users/rim/.local/bin"
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

    # Custom keybindings (Optional but helpful)
    initContent = ''
      # Ensure Homebrew CLI tools are available in interactive shells.
      export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Users/rim/.local/bin:$PATH"

      # Enable kubectl plugins installed via krew.
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

      # Initialize thefuck alias.
      eval "$(thefuck --alias)"

      # OCI CLI completion via argcomplete (non-interactive).
      if command -v register-python-argcomplete >/dev/null 2>&1; then
        eval "$(register-python-argcomplete --shell zsh oci 2>/dev/null)"
      fi

      # Bind up/down arrows to history search
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$kubernetes$aws$gcloud$azure$cmd_duration$character";

      directory = {
        truncation_length = 3;
      };

      git_branch = {
        symbol = "git:";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      kubernetes = {
        disabled = false;
        format = "[k8s:$context( $namespace)]($style) ";
        style = "bold cyan";
      };

      aws = {
        disabled = false;
        format = "[aws:$profile( @$region)]($style) ";
        style = "bold yellow";
      };

      gcloud = {
        disabled = false;
        format = "[gcp:$active( $project)]($style) ";
        style = "bold blue";
      };

      azure = {
        disabled = false;
        format = "[az:$subscription]($style) ";
        style = "bold blue";
      };
    };
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
