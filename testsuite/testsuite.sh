#!/bin/bash -x

set -euo pipefail
IFS=$'\n\t'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} install

${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
${PYTHON} ${DIR}/venv/bin/load_wrapper 6.1.5
${PYTHON} ${DIR}/venv/bin/house_keeping
${PYTHON} ${DIR}/venv/bin/bias_test 20 #100
