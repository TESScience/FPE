#!/bin/bash -x

set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON=${DIR}/venv/bin/python

make -C ${DIR} install

#${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
${PYTHON} ${DIR}/venv/bin/load_wrapper 6.1.5
${PYTHON} ${DIR}/venv/bin/load_wrapper 6.1.5
${PYTHON} ${DIR}/venv/bin/house_keeping
${DIR}/venv/bin/voltage_test --samples 20
${DIR}/venv/bin/bias_test --samples 20
${DIR}/venv/bin/rtd_test --samples 20
${PYTHON} ${DIR}/venv/bin/upload_fpe_program ${DIR}/program.fpe
${PYTHON} ${DIR}/venv/bin/start_frames
${PYTHON} ${DIR}/venv/bin/observatory_simulator_version
${PYTHON} ${DIR}/venv/bin/frames_running_status
${PYTHON} ${DIR}/venv/bin/stop_frames
${PYTHON} ${DIR}/venv/bin/frames_running_status
${PYTHON} ${DIR}/venv/bin/digital_house_keeping
${PYTHON} ${DIR}/venv/bin/start_frames
sleep 30
${PYTHON} ${DIR}/venv/bin/stop_frames
${PYTHON} ${DIR}/venv/bin/digital_house_keeping
