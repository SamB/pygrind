#!/usr/bin/env python

import pyximport
pyximport.install(setup_args={
        'options': {
            'build_ext': {
                'debug': True,
                },
            }
        })

import _pygrind
import testcode

p = _pygrind.Profiler()
p.profile(testcode.fib, [2])
p.profile(testcode.bar, [2])

