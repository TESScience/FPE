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


def unix_time_millis(dt):
    import datetime
    epoch = datetime.datetime.utcfromtimestamp(0)
    return (dt - epoch).total_seconds() * 1000.0

def check_DATE(test_check):
    """Check that the DATE was entered properly"""
    try:
        from dateutil.parser import parse
        import datetime
        DATE = parse(test_check["DATE"])
        assert unix_time_millis(datetime.datetime.now()) - unix_time_millis(DATE) > 0
    except Exception:
        assert False, "DATE not entered properly: {}".format(test_check["DATE"])

def check_FORM(test_check):
    """Checks the form"""
    if test_check is None:
        return False
    for k,v in test_check.iteritems():
        if v is dict:
            return check_FORM(v)
        elif v is None:
            return False
        else:
            return True



def check_FORM(test_check):
    """Checks the form"""
    if test_check is None:
        return False
    for k,v in test_check.iteritems():
        if v is dict:
            return check_FORM(v)
        elif v is None:
            return False
        else:
            return True



def check_house_keeping_voltages(fpe, tolerance=0.05):
    """Check the housekeeping voltages, up to a 5% tolerance"""
    # We apparently need to flip frames off and then on again before getting housekeeping
    fpe.cmd_start_frames()
    fpe.cmd_stop_frames()
    hsk = fpe.house_keeping
    for key, expected in voltage_reference_values.iteritems():
        if abs(hsk["analogue"][key] / expected - 1) > tolerance:
            raise Exception(
                "Housekeeping value for {key} should be {expected}, was {actual}".format(
                    key=key,
                    expected=expected,
                    actual=actual))
    return True
