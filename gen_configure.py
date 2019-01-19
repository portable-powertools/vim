#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys
import platform
import fnmatch
import os
import argparse
import textwrap

def makePy(arg1):
    """TODO: Docstring for makePy.

    :arg1: TODO
    :returns: TODO

    """
    pass

def makeArgs(cfgdir, is3):
    if is3:
        pflag='--enable-python3interp'
        pcflag='--with-python3-config-dir={}'.format(cfgdir)
    else:
        pflag='--enable-pythoninterp'
        pcflag='--with-python-config-dir={}'.format(cfgdir)

    return [
        pflag, pcflag, 
        '--with-features=huge', 
        '--enable-cscope', 
        '--enable-gui=gtk2', 
        '--enable-multibyte'
    ]

def findCfgDir(prefix):
    matches = []
    for root, dirnames, filenames in os.walk(prefix):
        for filename in fnmatch.filter(filenames, "libpython*"):
            matches.append(os.path.join(root, filename))
    return os.path.dirname(matches[0]) if matches else None

def main():
    versionname = "%s.%s" % platform.python_version_tuple()[0:2]
    prefix=""
    if hasattr(sys, "real_prefix"):
        prefix = sys.real_prefix
    elif hasattr(sys, "base_exec_prefix"):
        prefix = sys.base_exec_prefix
    else:
        prefix = sys.prefix

    cfgdir = findCfgDir("%s/lib/python%s" % (prefix, versionname))
    if not findCfgDir:
        print('could not find python config dir (no libpython* found)', file=sys.stderr)
        sys.exit(1)

    args = makeArgs(cfgdir, platform.python_version_tuple()[0] == '3')
    for a in args:
        print(a)

if __name__ == '__main__':
    main()

# main()
