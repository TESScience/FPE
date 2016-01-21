#!/usr/bin/env python2.7
"""This script performs measurements of reference voltages to verify functionality."""

if __name__ == "__main__":
    from tessfpe.dhu.fpe import FPE
    from tessfpe.data.housekeeping_channels import housekeeping_channels
    from tessfpe.dhu.unit_tests import voltage_reference_values
    from copy import deepcopy
    import numpy as np
    import pandas as pd
    import argparse
    import sys
    import tessfpe.report.ascii_plot as ap

    # Parse the command line arguments
    parser = argparse.ArgumentParser(description='Measure the voltages on the housekeeping to verify they match the reference values')
    parser.add_argument('samples', metavar='N', type=int, nargs='?', default=100, help='number of samples to take')
    parser.add_argument('--histograms', action='store_true', help='print histograms at the command line')
    args = parser.parse_args()
    
    with FPE(1) as fpe:
        keys = list(voltage_reference_values.keys())
        units = {k: housekeeping_channels[k]["unit"] for k in keys}
        reported_values = {k:[] for k in keys}

        for _ in range(args.samples):
            hk = deepcopy(fpe.house_keeping)
            for k in keys:
                reported_values[k].append(hk["analogue"][k])

        if args.histograms:
            for k in keys:
                print "Measurements for", k, "({0} Samples)".format(args.samples)
                ap.hist(reported_values[k])
            
        final_report = pd.DataFrame(
           np.transpose(
             [["{0:.4f} {1}".format(voltage_reference_values[k], units[k]) for k in keys],
              ["{0:.4f} {1}".format(np.average(reported_values[k]), units[k]) for k in keys],
              ["{0:.4f} {1}".format(np.std(reported_values[k]), units[k]) for k in keys]]),
           index=keys,
           columns=['Expected', 'Average', 'STD'])

        print "Samples: {0}".format(args.samples)
        print final_report
        sys.exit(0)  # 0 is SUCCESS for shell commands
