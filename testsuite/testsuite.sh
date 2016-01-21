#!/bin/bash -x

set -euo pipefail
IFS=$'\n\t'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} install

${PYTHON} ${DIR}/venv/bin/observatory_simulator_version.py
${PYTHON} ${DIR}/venv/bin/load_wrapper.py 6.1.5
${PYTHON} ${DIR}/venv/bin/reference_voltage_test.py 20 --histograms
