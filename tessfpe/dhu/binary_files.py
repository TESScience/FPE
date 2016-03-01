import tempfile


def write_mem_file(contents, fmt, file_name):
    """Writes a .mem binary file containing the specified contents with a set type
    :param contents: list
    :param fmt: str
    :param file_name: str
    :rtype : str
    """
    import struct
    if file_name is None:
        file_name = tempfile.mktemp('Binary.bin')
    data = ''.join(struct.pack(">" + fmt, x) for x in contents)
    if hasattr(file_name, 'write'):
        file_name.write(data)
        file_name.close()
        return file_name.name
    else:
        with open(file_name, 'wb') as f:
            f.write(data)
        return file_name


def write_regmem(contents, file_name=tempfile.mktemp('RegMem.bin')):
    """Write the Register memory; contains housekeeping and sequence control values.
    :param contents: list
    :param file_name: str
    :rtype : str
    """
    if file_name is None:
        file_name = tempfile.mktemp('RegMem.bin')
    if not len(contents) == 16 or \
            not all(type(x) is int for x in contents):
        raise Exception("Register memory should be a list of " +
                        "integers of length 16, was of length {length}:\n{contents}".format(
                            length=len(contents),
                            contents=contents))
    return write_mem_file(contents, 'H', file_name)


def write_seqmem(contents, file_name=None):
    """Write the Sequence memory; contains voltage sequences for controlling the CCD clocks.
    :param contents: list
    :param file_name: str
    :rtype : str
    """
    if file_name is None:
        file_name = tempfile.mktemp('SeqMem.bin')
    if not len(contents) == 1024 or \
            not all(type(x) is int for x in contents):
        raise Exception("Sequence memory should be a list of " +
                        "integers of length 1024, was of length {length}:\n{contents}".format(
                            length=len(contents),
                            contents=contents))
    return write_mem_file(contents, 'Q', file_name)


def write_prgmem(contents, file_name=None):
    """Write the Program memory; contains the programs that control the sequencer.
    :param contents: list
    :param file_name: str
    :rtype : str
    """
    if file_name is None:
        file_name = tempfile.mktemp('PrgMem.bin')
    if not len(contents) == 512 or \
            not all(type(x) is int for x in contents):
        raise Exception("Program memory should be a list of " +
                        "integers of length 512, was of length {length}:\n{contents}".format(
                            length=len(contents),
                            contents=contents))
    return write_mem_file(contents, 'Q', file_name)


def write_hskmem(contents, file_name=None):
    """Write the Housekeeping memory; contains values for housekeeping component sample selection.
    :param contents: list
    :param file_name: str
    :rtype : str
    """
    if file_name is None:
        file_name = tempfile.mktemp('HskMem.bin')
    if not len(contents) == 512 or \
            not all(type(x) is int for x in contents):
        raise Exception("Housekeeping memory should be a list of " +
                        "integers of length 512, was of length {length}:\n{contents}".format(
                            length=len(contents),
                            contents=contents))
    return write_mem_file(contents, 'B', file_name)


def write_clvmem(contents, file_name=None):
    """Write the clock level voltage memory; contains values for programming FPE clock level voltages
      (also known as *operating parameters*) via DACs.
    :param contents: list
    :param file_name: str
    :rtype : str
    """
    if file_name is None:
        file_name = tempfile.mktemp('CLVMem.bin')
    if not len(contents) == 128 or \
            not all(type(x) is int for x in contents):
        raise Exception("Housekeeping memory should be a list of " +
                        "integers of length 128, was of length {length}:\n{contents}".format(
                            length=len(contents),
                            contents=contents))
    return write_mem_file(contents, 'H', file_name)
