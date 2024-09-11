#!/usr/bin/env bash

echo "### Bootstrap: Authorize with GitHub"
gh auth login

echo "### Bootstrap: Cloning Modular repository"
mkdir -p ~/src
cd ~/src
gh repo clone https://github.com/modularml/modular
cd modular
git submodule update --init

echo "### Bootstrap: Setting up Modular repository"
. ./utils/start-modular.sh
install_python_deps
install_dev_deps
utils/install-llvm.sh
