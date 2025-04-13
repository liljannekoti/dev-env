{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-wsl/modules>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nixpkgs.config.allowUnfree = true;
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs;
    [
      vscode
      vscode.fhs
      vim
      wget
      neovim
      git
      stow
      gh
      zig
      gcc
      clang
      nodejs
      unzip
      cargo
      hugo
      ripgrep
      fd
      go
    ];

  environment = {
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  system.stateVersion = "24.11";
}
