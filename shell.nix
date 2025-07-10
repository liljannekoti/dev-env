{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    python3Full
    dart-sass
    nodejs
    hugo
    go
    just

    wget
    git
    gh
    unzip

    neovim
    ripgrep
    tmux
    fzf
    fd
  ];
}
