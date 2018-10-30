{pkgs, ...}:

let
  meeting = pkgs.writeScriptBin "meeting" (builtins.readFile ./scripts/meeting.sh);
  shell = pkgs.writeScriptBin "shell" ''
    #!/usr/bin/env bash

    RUNINDIR=""
    CMD=""
    while getopts "hc:e:" arg; do
      case "''${arg}" in
        h)
          echo "Shell wrapper USAGE"
          echo "  -h\tThis help text"
          echo "  -e\tRun command"
          echo "  -c\tChange directory"
          exit 0
          ;;
        c)
          RUNINDIR="-cd ''${OPTARG}"
          ;;
        e)
          CMD="-e ''${OPTARG}"
          ;;
      esac
    done

    ${pkgs.rxvt_unicode}/bin/urxvt ''${RUNINDIR} ''${CMD}
  '';

in


{
  # See https://github.com/rycee/home-manager/blob/master/modules/programs/zsh.nix
  programs.zsh = {
    enable = true;
    shellAliases = {
      "nix-build" = "nix build";
      "nix--build" = "${pkgs.nix}/bin/nix-build";
      "nix-shell" = "echo use nix run instead or nix--shell";
      "nix--shell" = "${pkgs.nix}/bin/nix-shell";
      mkae = "make";
      mutt = "${pkgs.neomutt}/bin/neomutt";
      ls = "ls -N --color=auto";
      # Play a sound of "rolling waves"
      # Taken from https://askubuntu.com/a/789472
      noise = "${pkgs.sox}/bin/play -n synth brownnoise synth pinknoise mix synth sine amod 0.2 10";
      # https://theptrk.com/2018/07/11/did-txt-file/
      did = ''${pkgs.nvim}/bin/nvim +"normal Go" +"r!date" ~/did.txt'';
    };
    enableAutosuggestions = true;
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      PATH = "$HOME/.local/bin:$PATH";
    };
    history = {
      save = 10000;
      size = 10200;
      ignoreDups = false;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
      path = ".zhistory";
    };
    plugins = [
      {
        name = "wunjo";
        src = ./zsh/wunjo;
      }
      {
        name = "gwp";
        src = ./zsh/gwp;
      }
    ];
    initExtra = ''
      bindkey -v
      autoload -U edit-command-line
      zle -N edit-command-line

      bindkey "^?" backward-delete-char
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line
      bindkey '^[[5~' up-line-or-history
      bindkey '^[[6~' down-line-or-history
      bindkey '^[[B' history-search-forward
      bindkey '^[[A' history-search-backward
      bindkey "^r" history-incremental-search-backward
      bindkey ' ' magic-space    # also do history expansion on space
      bindkey '^E' complete-word # complete on tab, leave expansion to _expand
      bindkey -M vicmd v edit-command-line

      setopt prompt_sp # print lines without newlines properly

      if [ ! -f $HOME/.reminders ]; then
        touch $HOME/.reminders
      fi
      ${pkgs.remind}/bin/remind -m -c+ ~/.reminders
    '';
  };
  home.packages = with pkgs; [
    shell
    nvim

    # scripts
    meeting
  ];
  programs.urxvt = {
    enable = true;
    fonts = [ "xft:Iosevka\\ Term:size=11" ];
    iso14755 = false;
    scroll = {
      bar.enable = false;
      lines = 4000;
      keepPosition = true;
    };
    extraConfig = {
      "pointerBlank" = true;
      "perl-ext-common" = "default,matcher,searchable-scrollback";
    };
  };
  xresources = {
    properties = {
      "Xcursor.theme" = "oxy-white";
      "Xft*antialias" = true;
      "Xft*dpi" = 96;
      "Xft*hinting" = true;
      "Xft*hintstyle" = "hintfull";
      "Xft*rgba" = "rgb";
      "dzen2.font" = "xft:Iosevka:pixelsize=13";
    };
    extraConfig = builtins.readFile ./Xresources;
  };

}
