#!/usr/bin/env bash

# This script sets up a machine for using my personal home-manager configuration

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Clean out any accidental cruft
rm -rf ~/.config/home-manager

# Enable flakes and nix-command features
mkdir -p "${HOME}/.config/nix/"
echo "experimental-features = nix-command flakes" > "${HOME}/.config/nix/nix.conf"

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Check out my home-manager installation
rm -rf ~/.config/home-manager
git clone https://github.com/sabauma/home-manager.git ~/.config/home-manager

# Build home-manager config
pushd ~/.config/home-manager
git checkout modular-laptop
home-manager switch --flake ".#ubuntu" -b backup
popd


