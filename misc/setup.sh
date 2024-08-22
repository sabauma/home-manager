#!/usr/bin/env bash

# This script sets up a machine for using my personal home-manager configuration

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

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
home-manager \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  switch --flake ".#spenser" -b backup
popd


