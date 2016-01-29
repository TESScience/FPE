#!/bin/bash -x

set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} install

${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
${PYTHON} ${DIR}/venv/bin/load_wrapper 6.1.5
${PYTHON} ${DIR}/venv/bin/house_keeping
${DIR}/venv/bin/voltage_test --samples 20
${DIR}/venv/bin/bias_test --samples 20
${DIR}/venv/bin/rtd_test --samples 20

# These test basic start and stop frame functinality, they are currently broken
#${PYTHON} ${DIR}/venv/bin/start_frames
#${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
#${PYTHON} ${DIR}/venv/bin/frames_running_status
#${PYTHON} ${DIR}/venv/bin/stop_frames
#${PYTHON} ${DIR}/venv/bin/frames_running_status
