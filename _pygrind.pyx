# This file is offered under the Expat license or the WTFPL, at your option.

from cpython.pystate cimport *

cdef extern from "frameobject.h":
    cdef struct _frame
    cdef class types.FrameType [object _frame,
                                #type PyFrame_Type,
                                ]:
        pass

cdef extern from "Python.h":
    #ctypedef PyFrameObject _frame
    ctypedef int (*Py_tracefunc)(object, FrameType frame, int, object) except -1

cdef extern from "ceval.h":
    cdef void PyEval_SetProfile(Py_tracefunc, object)
    cdef void PyEval_SetTrace(Py_tracefunc, object)

import inspect
import pprint

def _fmt_frame(f):
    #pprint.pprint(inspect.getmembers(f), depth=1)
    print "f_code:   %r" % f.f_code
    print "f_lasti:  %d" % f.f_lasti
    print "f_lineno: %d" % f.f_lineno

cdef class Profiler:
    cdef int _tracefunc(self, _frame *frame, int what, PyObject *_arg) except -1:

        if _arg:
            arg = <object>_arg
        else:
            arg = None

        if what == PyTrace_CALL:
            print "CALL"
        elif what == PyTrace_EXCEPTION:
            print "EXCEPTION %r" % (arg,)
        elif what == PyTrace_LINE:
            print "LINE"
        elif what == PyTrace_RETURN:
            print "RETURN %r" % arg
        elif what == PyTrace_C_CALL:
            print "C_CALL %r %r" % (arg, type(arg))
        elif what == PyTrace_C_EXCEPTION:
            print "C_EXCEPTION"
        elif what == PyTrace_C_RETURN:
            print "C_RETURN"

        if frame:
            _fmt_frame(<FrameType>frame)

    def profile(self, fun, args=[], kwargs={}):
        #PyEval_SetTrace(<Py_tracefunc>Profiler._tracefunc, self)
        PyEval_SetProfile(<Py_tracefunc>Profiler._tracefunc, self)
        try:
            x = fun(*args, **kwargs)
        finally:
            #PyEval_SetTrace(NULL, None)
            PyEval_SetProfile(NULL, None)
