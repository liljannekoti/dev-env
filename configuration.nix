{ config, lib, pkgs, ... }:

# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable && sudo nix-channel --update
{
  imports = [
    <nixos-wsl/modules>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

  networking.firewall = {
    enable = true;
  };

  users.users.perttu = {
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  wsl.enable = true;
  wsl.defaultUser = "perttu";

  virtualisation.docker = {
    enable = true;

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
      unstable.neovim
      vscode
      vscode.fhs
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
      fd
      go
      eza
      fzf
    ];

  environment = {
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.bash.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -al";
  };

  system.stateVersion = "24.11";
}
