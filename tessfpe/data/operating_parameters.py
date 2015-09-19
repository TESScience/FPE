"""
This module gives a data structure wrapping the operating parameters
for the TESS Focal Plane Electronics (FPE), as described in Section 6 of
the manual.

https://raw.githubusercontent.com/TESScience/FPE/master/FPE/Documentation/FPE.pdf
"""

from data import read_data_tsv

defaults = {v: float(k) for (v, k) in read_data_tsv("DefaultParameters.tsv")}


def get_operating_parameters(tsv_file_name):
    "Extract the operating parameters from a data TSV file"
    return {line[1].lower().replace(' ', '_'):
                {"address_offset": int(line[0]),
                 "low": float(line[4]),
                 "high": float(line[5]),
                 "unit": line[8],
                 "default": defaults[line[1]]}
            for line in read_data_tsv(tsv_file_name)
            if line[4] != '' and line[5] != ''}


# Operating Parameters for the FPE
operating_parameters = \
    {("ccd" + ccd + '_' if ccd != '' else '') + entry_name:
         {"address": int(address_offset) + entry["address_offset"],
          "low": entry["low"],
          "high": entry["high"],
          "unit": entry["unit"],
          "default": entry["default"]}
     for address_offset, ccd, group in read_data_tsv("HKmap.tsv")
     for entry_name, entry in get_operating_parameters(
        group.replace(' ', '') + ".tsv").iteritems()}

# Memory map for operating parameters
operating_parameter_memory_map = [None for _ in range(128)]
for entry_name, entry in operating_parameters.iteritems():
    operating_parameter_memory_map[entry["address"]] = entry_name
