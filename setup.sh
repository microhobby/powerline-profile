#!/usr/bin/env bash

pipx install powerline-shell
pipx inject powerline-shell psutil

# add the ./.bashrc to your ~/.bashrc
mv ~/.bashrc ~/.bashrc_old

ln -s $HOME/projects/B/powerline-profile/.bashrc \
    $HOME/.bashrc

# make the symlink to powerline-shell config
mkdir -p ~/.config/powerline-shell
ln -s $HOME/projects/B/powerline-profile/config.json \
    $HOME/.config/powerline-shell/config.json
