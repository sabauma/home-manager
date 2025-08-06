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
NP_RUNTIME=bwrap nix-portable nix --option sandbox false shell nixpkgs#{bashInteractive,nix} <<EOF
nix --option sandbox false run github:nix-community/home-manager -- init
EOF

rm -rf /homeless-shelter
rm -rf ~/.nix-portable/emptyroot/homeless-shelter

# Add home-manager to its own path
echo 'Add the following in your home.nix file: `home.sessionVariables.PATH = "$HOME/.nix-profile/bin:$PATH";`'
# sed -i '/home.sessionVariables = {/a\    PATH = "$HOME/.nix-profile/bin:$PATH";' ~/.config/home-manager/home.nix

# home manager switch
NP_RUNTIME=bwrap nix-portable nix --option sandbox false shell nixpkgs#{bashInteractive,nix} <<EOF
nix --option sandbox false run github:nix-community/home-manager -- switch -b backup
EOF

rm -rf /homeless-shelter
rm -rf ~/.nix-portable/emptyroot/homeless-shelter

# Make new sessions use the shell automatically
cat >~/.bashrc <<EOF
export PATH=\$PATH:\$HOME/.local/bin

if [ -z "\$__NIX_PORTABLE_ACTIVATED" ]; then
        export __NIX_PORTABLE_ACTIVATED=1
        NP_RUNTIME=bwrap nix-portable nix --option sandbox false run nixpkgs#bashInteractive --offline
        exit
else
        . \$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

# Set something for the cmd line
PS1='[\u@\h \W]\\\$ '
EOF

echo 'Please remember to relogin so that the environment gets activated'
