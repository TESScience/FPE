#!/usr/bin/env python
"""
The `tessfpe` python module provides datastructures for managing 
operating parameters and housekeeping  channels for the TESS 
Focal Plane Electronics (FPE).

Operating parameters and housekeeping channels are described in 
Section 6 of the TESS FPE manual (TODO: Link to manual)

This file exports two dictionaries:
	- `operating_parameters`
	- `housekeeping_parameters`

Each of these dictionaries has labeled entries associated `high` and 
`low` values, along with a `unit` and associated `address` value in memory

>>> operating_parameters['ccd1_input_diode_high'] 
{'high': 15.0, 'low': 0.0, 'unit': 'V', 'address': 70}
>>> housekeeping_parameters['ccd1_input_diode_high'] 
{'high': 16.5, 'low': -16.5, 'unit': 'V', 'address': 70}
"""

import os

# Data directory where TSV files live that hold parameters of interest
data_dir = os.path.normpath(
		os.path.join(os.path.dirname(os.path.realpath(__file__)),
                             "AE", "Data"))

def read_data_tsv(tsv_file_name):
	"""Reads a Tab Seperated Value file (TSV) 
	   from the Data directory into a list of rows"""
	import csv
	with open(os.path.join(data_dir,tsv_file_name)) as tsv:
		return [line for line in 
                        csv.reader(tsv, dialect="excel-tab")]

def get_operating_parameters(tsv_file_name):
	"Extract the operating parameters from a data TSV file"
	return {line[1].lower().replace(' ', '_'): 
                {"address_offset": int(line[0]),
                 "low": float(line[4]),
                 "high": float(line[5]),
                 "unit": line[8]} 
		for line in read_data_tsv(tsv_file_name)
		if line[4] != '' and line[5] != ''}

def get_housekeeping_parameters(tsv_file_name):
	"Extract the housekeeping parameters from a data TSV file"
	return {line[1].lower().replace(' ', '_'): 
                {"address_offset": int(line[0]),
                 "low": float(line[2]),
                 "high": float(line[3]),
                 "unit": line[8]} 
		for line in read_data_tsv(tsv_file_name)
		if line[2] != '' and line[3] != ''}


# Operating Parameters for the FPE
operating_parameters = \
	{("ccd" + ccd + '_' if ccd != '' else '') + entry_name: 
	 {"address": int(address_offset) + entry["address_offset"],
	  "low": entry["low"],
	  "high": entry["high"],
	  "unit": entry["unit"]}
         for address_offset, ccd, group in read_data_tsv("HKmap.tsv")
         for entry_name, entry in get_operating_parameters(
		 group.replace(' ','') + ".tsv").iteritems()}

# Housekeeping Parameters for the FPE
housekeeping_parameters = \
	{("ccd" + ccd + '_' if ccd != '' else '') + entry_name: 
	 {"address": int(address_offset) + entry["address_offset"],
	  "low": entry["low"],
	  "high": entry["high"],
	  "unit": entry["unit"]}
         for address_offset, ccd, group in read_data_tsv("HKmap.tsv")
         for entry_name, entry in get_housekeeping_parameters(
		 group.replace(' ','') + ".tsv").iteritems()}

if __name__ == "__main__":
	__import__("doctest").testmod()
