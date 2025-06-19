{ config, lib, pkgs, ... }:
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable && sudo nix-channel --update
{
  imports = [
    <nixos-wsl/modules>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  programs.nix-ld.enable = true;

  wsl = {
    enable = true;
    defaultUser = "perttu";
    docker-desktop.enable = true;
  };

  # vscode server for wsl and ssh
  services.vscode-server.enable = true;

  networking.firewall = {
    enable = false;
  };

  users.users.perttu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs;
    [
  (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
    ];
  })
      jdt-language-server
      lua-language-server
      vscode-js-debug
      unstable.neovim
      rust-analyzer
      texliveFull
      vscode.fhs
      zoxide
      lombok
      docker
      maven
      tmux
      vim
      wget
      git
      stow
      gh
      zig
      gcc
      clang
      nodejs
      unzip
      cargo
      ripgrep
      bat
      fd
      eza
      fzf
      lua
      python3Full
      gnumake
    ];

  programs.java = { enable = true; };

  environment = {
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.bash.shellAliases = {
    ls = "eza --color=always --group-directories-first";
    ll = "eza -l --color=always --group-directories-first --git --git-repos";
    la = "eza -a --color=always --group-directories-first";
    lla = "eza -alhF --color=always --group-directories-first --git --git-repos";
  };

  services.openssh = {
    enable = false;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "25.05";
}
