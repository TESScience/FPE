#!/usr/bin/env python2.7
"""This script checks the version number from the Observatory Simulator firmware and is effectively a sanity check that the firmware is properly installed"""

if __name__ == "__main__":
    from tessfpe.dhu.fpe import FPE
    from tessfpe.dhu.unit_tests import check_house_keeping_voltages
    import sys
    
    with FPE(1, check_hk=False) as fpe:
        print fpe.version
        sys.exit(0)  # 0 is SUCCESS for shell commands
