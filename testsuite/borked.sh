#!/bin/bash -x

set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} reinstall

${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
${PYTHON} ${DIR}/venv/bin/load_wrapper --debug 6.2.2
