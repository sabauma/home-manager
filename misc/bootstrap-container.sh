#!/bin/bash

set -ex
export PATH=$PATH:$HOME/.local/bin
mkdir -p .local/bin
cd .local/bin

# Download nix-portable
curl -L "https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m)" >./nix-portable

# Generate symlinks for seamless integration
chmod +x nix-portable
ln -s nix-portable nix || true
ln -s nix-portable nix-channel || true
ln -s nix-portable nix-copy-closure || true
ln -s nix-portable nix-env || true
ln -s nix-portable nix-instantiate || true
ln -s nix-portable nix-prefetch-url || true
ln -s nix-portable nix-store || true
ln -s nix-portable nix-build || true
ln -s nix-portable nix-collect-garbage || true
ln -s nix-portable nix-daemon || true
ln -s nix-portable nix-hash || true
ln -s nix-portable nix-shell || true

cd ~

rm -rf /homeless-shelter
rm -rf ~/.nix-portable/emptyroot/homeless-shelter

# Init home-manager
NP_RUNTIME=bwrap nix-portable nix shell nixpkgs#{bashInteractive,nix} <<EOF
nix --option sandbox false run github:nix-community/home-manager -- init
EOF

rm -rf /homeless-shelter || true
rm -rf ~/.nix-portable/emptyroot/homeless-shelter || true

# Add home-manager to its own path
echo 'Add the following in your home.nix file: `home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";`'
# sed -i '/home.sessionVariables = {/a\    PATH = "$HOME/.nix-profile/bin:$PATH";' ~/.config/home-manager/home.nix

# home manager switch
NP_RUNTIME=bwrap nix-portable nix shell nixpkgs#{bashInteractive,nix} <<EOF
nix --option sandbox false run github:nix-community/home-manager -- switch -b backup
EOF

rm -rf /homeless-shelter || true
rm -rf ~/.nix-portable/emptyroot/homeless-shelter || true

# Make new sessions use the shell automatically
NP_RUNTIME=bwrap nix-portable nix run nixpkgs#bashInteractive --offline
