{
  config,
  pkgs,
  ...
}: let
  libpng =
    pkgs.libpng.overrideAttrs (_: {meta.outputsToInstall = _.outputs;});
  username = "edwlan";
  homeDirectory = "/Users/${username}";
  dotfileDirectory = "${homeDirectory}/git_repos/dotfiles";

  alejandra =
    (import (builtins.fetchTarball {
      url = "https://github.com/kamadorueda/alejandra/tarball/1.1.0";
      sha256 = "0r8d4pllz3rar5b8xlk332mm395nj6w1zh6dnpbz7156fii4lhdy";
    }))
    # Pick one from: aarch64-darwin, aarch64-linux, i686-linux, x86_64-darwin, x86_64-linux
    .aarch64-darwin;

  # zsh = pkgs.zsh.overrideAttrs ({postInstall}: {postInstall = ''
  #   make install.info install.html
  #   '' + postInstall})

  common_home =
    import "${dotfileDirectory}/nix/common.nix" {inherit homeDirectory pkgs;};
in {
  nixpkgs.overlays = common_home.overlays;

  ## Doesn't work???
  #xdg.configFile."nixpkgs/overlays".source = ./elangley-overlay;

  home.packages =
    common_home.packages
    ++ [
      libpng
      pkgs.libssh2
      pkgs.openssl
      pkgs.pandoc
      alejandra
      (pkgs.emacsGit.override {nativeComp = true;})
    ];

  programs = {
    tmux = {
      enable = true;
      terminal = "screen-256color";
      escapeTime = 0;
      clock24 = true;
      newSession = true;
      keyMode = "vi";
      extraConfig = builtins.readFile (dotfileDirectory + "/tmux.conf");
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}