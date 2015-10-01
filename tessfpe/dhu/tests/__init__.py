"""This module contains various tests for the TESS
focal plane electronics related to housekeeping"""

voltage_reference_values = {
    "+1.8f": 1.8,
    "+15": 15,
    "+1f": 1,
    "+2.5f": 2.5,
    "+3.3f": 3.3,
    "+5": 5,
    "-12": -12
}


def check_house_keeping_voltages(fpe, tolerance=0.05):
    """Check the housekpeeing voltages, up to a 5% tolerance"""
    hsk = fpe.house_keeping
    for key, expected in voltage_reference_values.iteritems():
        if abs(hsk[key] / expected - 1) > tolerance:
            raise Exception(
                "Housekeeping value for {key} should be {expected}, was {actual}".format(
                    key=key,
                    expected=expected,
                    actual=actual))
    return True
