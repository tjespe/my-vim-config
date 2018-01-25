#!/bin/bash
cd "${0%/*}"
git pull
git submodule init
git submodule update
vim -E -c PluginInstall -c q -c q -c q
echo "Installation complete!"
