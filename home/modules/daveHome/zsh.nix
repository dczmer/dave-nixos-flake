{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.daveHome.zsh;
  ps1var = "\$(env_status)\${vcs_info_msg_0_} %F{#4EA1FF} %f%1d%0(?.. %F{#ff6e5e}%?%f)%F{#4EA1FF}>%f ";
in
{
  options.daveHome.zsh = {
    enable = mkEnableOption "ZSH";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      fzf
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      completionInit = "autoload -U compinit && compinit= ";
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        "vi" = "nvim";
        "vim" = "nvim";
        "ls" = "ls --color";
        "ll" = "ls --color -l";
        "la" = "ls --color -al";
        "nix-flake-init" = "nix flake init -t github:numtide/flake-utils#each-system";
        "wake-guinness" = "wol d8:bb:c1:00:86:3b";
        "add-ssh-keys" = "grep -slR 'PRIVATE' ~/.ssh/keys | xargs ssh-add; ssh-add -l";
      };
      history = {
        append = true;
        expireDuplicatesFirst = false;
        extended = true;
        findNoDups = false;
        ignoreAllDups = false;
        ignoreDups = true;
        ignoreSpace = true;
        path = "$HOME/.zsh_history";
        saveNoDups = false;
        save = 50000;
        share = true;
        size = 50000;
      };
      historySubstringSearch = {
        enable = true;
        searchUpKey = "$terminfo[kcuu1]";
        searchDownKey = "$terminfo[kcud1]";
      };
      initContent = ''
        export GREP_COLOR='3;33'
        export LESS='--ignore-case --raw-control-chars'
        export EDITOR='nvim'
        export LC_COLLATE=C
        export KEYTIMEOUT=1
        export path=($path "/home/dave/bin")

        # GIT/VCS Prompt Support
        autoload -Uz vcs_info
        precmd() {
            vcs_info
        }
        zstyle ':vcs_info:*' formats '%s(%F{#ff6e5e}%b%f)'
        zstyle ':vcs_info:git:*' formats '%F{#5eff6c} %f(%b)%F{#ffbd5e}%u%c%f'
        zstyle ':vcs_info:git:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr " "
        zstyle ':vcs_info:git:*' unstagedstr " "
        zstyle ':vcs_info:git:*' actionformats '%F{#5eff6c} %f(%F{#ffbd5e}%b%f|%F{#ff6e5e}%a%f)'
        setopt prompt_subst

        env_status () {
            results=""
            if [[ $IN_NIX_SHELL == "impure" ]]; then
                results="%F{#CCCCCC}󱄅 %f"
            elif [[ $IN_NIX_SHELL == "pure" ]]; then
                results="%F{#4EA1FF}󱄅 %f"
            fi
            if [[ -n $VIRTUAL_ENV ]]; then
                results="''${results}%F{#ffbd5e} %f"
            fi
            echo $results
        }

        export PS1='${ps1var}'
        export RPROMPT='%F{#4EA1FF}<%f%1(j.%F{#ffbd5e}%j%f.) %F{#4EA1FF}%T%f'

        # Auto-complete engine:
        autoload -Uz compinit bashcompinit
        compinit
        bashcompinit
        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
        zstyle ':completion:*' menu select search
        zstyle ':completion:*:*:*:*:descriptions' format '%F{#5eff6c}-- %d --%f'
        zstyle ':completion:*:*:*:*:corrections' format '%F{#ffbd5e}!- %d (errors: %e) -!%f'
        zstyle ':completion:*:messages' format ' %F{#BD5EFF} -- %d --%f'
        zstyle ':completion:*:warnings' format ' %F{#ff6e5e}-- no matches found --%f'
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:default' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' squeeze-slashes true
        unsetopt MENU_COMPLETE

        # TODO: implement these as nix config settings: https://home-manager-options.extranix.com/?query=fzf&release=release-25.05
        export FZF_DEFAULT_COMMAND="rg --files --hidden --glob *"
        export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_DEFAULT_OPTS='--tmux
          --color=fg:#CCCCCC,fg+:#FFBD5E,bg:#121212,bg+:#262626
          --color=hl:#4EA1FF,hl+:#00a0fd,info:#FFBD5E,marker:#5EFF6C
          --color=prompt:#FF6E5E,spinner:#BD5EFF,pointer:#BD5EFF,header:#4EA1FF
          --color=border:#262626,preview-fg:#000000,preview-bg:#262626,label:#aeaeae
          --color=query:#d9d9d9
          --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
          --marker=">" --pointer="󰋇 " --separator="─" --scrollbar="│"'
        eval "$(fzf --zsh)"

        bindkey -v
        autoload edit-command-line
        zle -N edit-command-line
        bindkey "^e" edit-command-line
        bindkey "^K" kill-whole-line
        bindkey "^R" history-incremental-search-backward
        bindkey "''${terminfo[khome]}" beginning-of-line
        bindkey "''${terminfo[kend]}" end-of-line
      '';
    };
  };
}
