#!/bin/bash -x

set -euo pipefail
IFS=$'\n\t'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} install

${PYTHON} ${DIR}/venv/bin/start_frames
${PYTHON} ${DIR}/venv/bin/stop_frames
