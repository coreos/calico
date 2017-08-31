#!/bin/bash
set -euo pipefail
cd "$( dirname "${BASH_SOURCE[0]}" )"

CONFIG_MAP_NAME=${CONFIG_MAP_NAME:-calico-bird-templates}
if [[ ${OUT_PATH:-} == "" ]];then
  echo "USAGE: OUT_PATH=/path/to/calico-bird-templates.yaml $0"
  exit 1
fi

if [[ `git diff --shortstat 2> /dev/null | tail -n1` != "" ]];then
  echo "`pwd`: git working tree is dirty"
  exit 1
fi

which kubectl &> /dev/null || echo '"kubectl" executable not found on $PATH'

kubectl create configmap $CONFIG_MAP_NAME --dry-run --from-file=./templates --from-literal=git-version=`git rev-parse HEAD` -o=yaml > "${OUT_PATH}"

printf "Wrote configmap ${CONFIG_MAP_NAME}:\n${OUT_PATH}\n"
