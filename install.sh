#!/bin/bash
cd "${0%/*}"
if [ ! -f bundle/last-update ] || (($(date +%s) > $(cat bundle/last-update 2> /dev/null) + 10))
then
  if [ -f bundle/last-update ]; then
    git pull > /dev/null
    git submodule init > /dev/null
    git submodule update > /dev/null
  else
    git pull
    git submodule init
    git submodule update
  fi
  date +%s > bundle/last-update
  vim -E -c PluginInstall -c q -c q -c q
  echo "Installation complete!"
fi
