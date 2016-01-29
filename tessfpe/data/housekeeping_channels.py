# -*- coding: utf-8 -*-
"""
This module gives a data structure wrapping the housekeeping channels
for the TESS Focal Plane Electronics (FPE), as described in Section 6 of
the manual.

https://raw.githubusercontent.com/TESScience/FPE/master/FPE/Documentation/FPE.pdf
"""

from data import read_data_tsv

def get_housekeeping_channels(tsv_file_name):
    "Extract the housekeeping parameters from a data TSV file"
    return {line[1].lower().replace(' ', '_'):
                {"address_offset": int(line[0]),
                 "low": float(line[2]),
                 "high": float(line[3]),
                 "unit": line[8]}
            for line in read_data_tsv(tsv_file_name)
            if line[2] != '' and line[3] != ''}

# Housekeeping parameters for the FPE
housekeeping_channels = \
    {("ccd" + ccd + '_' if ccd != '' else '') + entry_name:
         {"address": int(address_offset) + entry["address_offset"],
          "low": entry["low"],
          "high": entry["high"],
          "unit": entry["unit"],
          "ccd": ccd,
          "group": group,
          "name": entry_name}
     for address_offset, ccd, group in read_data_tsv("HKmap.tsv")
     for entry_name, entry in get_housekeeping_channels(
        group.replace(' ', '') + ".tsv").iteritems()}

# Housekeeping map for housekeeping parameters
housekeeping_channel_memory_map = 128 * [None]
for entry_name, entry in housekeeping_channels.iteritems():
    housekeeping_channel_memory_map[entry["address"]] = entry_name

def add_hsk_units(hsk_dict, suffix=""):
    "Takes a dictionary of housekeeping units and makes a new one with units attached (takes an optional suffix)"
    return {k: "{0} {1} {2}".format(v, housekeeping_channels[k]["unit"], suffix)
            for k,v in hsk_dict.iteritems()}

def report_table(data, expected_values={}, precision=4, keys=None):
    """Make a table (string) reporting the values of housekeeping data"""
    import numpy as np
    import pandas as pd
    if keys == None:
        keys = data.keys()
        keys.sort()
    units = {k: housekeeping_channels[k]["unit"] for k in keys}
    # If we only have one sample for every channel, we don't need to report statistics
    if all(isinstance(v, (list, set, tuple)) for v in data.values()) and \
       all(len(v) == 1 for v in data.values()):
        for k in keys:
            data[k] = data[k][0]
    if all(isinstance(v, (list, set, tuple)) for v in data.values()):
        samples_text = u"Samples: {0}\n".format(len(data.values()[0])) \
                       if len(set([len(v) for v in data.values()])) == 1 else u""
        report = pd.DataFrame(
           np.transpose(
             [[(u"{0:." + unicode(precision) + "f} {1}").format(expected_values[k], units[k]) \
               if k in expected_values else "N/A" 
               for k in keys],
              [(u"{0:." + unicode(precision) + "f} {1}").format(np.average(data[k]), units[k])
               for k in keys],
              [(u"{0:." + unicode(precision) + "f} {1}").format(np.std(data[k]), units[k])
               for k in keys],
              [u"{0} {1}²".format(np.var(data[k]), units[k])
               for k in keys]]),
           index=keys, 
           columns=[u' Expected', u' Average', u' STD', u' Variance'])

        if list(report[u' Expected'].unique()) == [u'N/A']:
            del report[u' Expected']
    else:
        samples_text = u""
        report = pd.DataFrame(
           np.transpose(
             [[(u"{0:." + unicode(precision) + "f} {1}").format(expected_values[k], units[k]) \
               if k in expected_values else "N/A" 
               for k in keys],
              [(u"{0:." + unicode(precision) + "f} {1}").format(data[k], units[k])
               for k in keys]]),
           index = keys,
           columns = [u' Expected', u' Actual'])
        if list(report[u' Expected'].unique()) == [u'N/A']:
            del report[u' Expected']
            report.columns = ['']

    return samples_text + \
           report.to_string(justify='left',
                            formatters={col:u'{{:<{}s}}'.format(report[col].str.len().max()).format
                                        for col in report.columns.values})
