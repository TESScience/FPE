#!/usr/bin/env python
"""
This module wraps reading TSVs that are used to specify the
TESS Focal Plane Electronics (FPE) design.

https://raw.githubusercontent.com/TESScience/FPE/master/FPE/Documentation/FPE.pdf
"""

# Data directory where TSV files live that hold parameters of interest
import os
data_dir = os.path.normpath(
        os.path.join(os.path.dirname(os.path.realpath(__file__)),
                     "files"))

def read_data_tsv(tsv_file_name):
    """Reads a Tab Seperated Value file (TSV)
       from the Data directory into a list of rows"""
    import csv
    with open(os.path.join(data_dir,tsv_file_name)) as tsv:
        return [line for line in csv.reader(tsv, dialect="excel-tab")]
