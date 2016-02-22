#!/usr/bin/env python


def timing_sequence(ast, sequence_name, sequencer_bits=None, debug=False):
    """Outputs the timings ast list for a particular sequence in an AST."""
    sequence = ast["sequences"][sequence_name]["sequence"]
    defaults = ast["defaults"]
    if sequencer_bits is None:
        sequencer_bits = list(set(k for i in sequence
                                  for k in i.keys() if k != "steps") |
                              set(k for k in defaults))
        sequencer_bits.sort()
        if debug:
            print "No sequencer bits specified, using: {}".format(sequencer_bits)
    if isinstance(sequencer_bits, basestring):
        sequencer_bits = [sequencer_bits]
    return "\n".join(timing_for_bit(sequence, sequence_name, bit, get_default_value(defaults, bit))
                     for bit in sequencer_bits)


def timing_letter(voltage_level):
    """Converts a voltage level to the appropriate tikz timing letter"""
    if voltage_level in ["low", "vlow"]:
        return "vlow"
    if voltage_level in ["high", "vhigh"]:
        return "vhigh"
    else:
        raise Exception(
            'Specified voltage level must be one of "low", "vlow", "high" or "vhigh", was: ' + voltage_level)


def get_default_value(defaults, sequencer_bit):
    return timing_letter(defaults[sequencer_bit]) \
        if sequencer_bit in defaults else "vlow"


def timing_for_bit(sequence, sequence_name, sequencer_bit, default_value="vlow"):
    """Create a TikZ timing diagram for sequencer AST for a given sequencer bit"""
    values = []
    level = default_value
    for s in sequence:
        if "steps" in s:
            for _ in range(s["steps"]):
                values.append(level)
        if sequencer_bit in s:
            level = timing_letter(s[sequencer_bit])
    values += [values[-1] for _ in range(max(0, 24 - len(values)))]
    sequence_title = '* Sequence: {}, Bit: {} *'.format(sequence_name, sequencer_bit.upper())
    sep = '*' * len(sequence_title)
    return (sep + '\n' +
            sequence_title + '\n' +
            sep + '\n\n' +
            'V{0} {0} 0 PWL\n'.format(sequencer_bit.upper().replace('-', '_')) +
            '+0 {{{}}}\n'.format(default_value) +
            "\n".join(
                ('+{{{idx}*tclock+trise}}{{{value}}}\n' +
                 '+{{{idx}*tclock+trise}}{{{value}}}').format(
                    idx=idx, value=value) for (idx, value) in enumerate(values)) +
            '\n')
