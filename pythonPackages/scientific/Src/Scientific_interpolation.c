/* Generated by Pyrex 0.9.6.2 on Fri Feb  8 17:18:41 2008 */

#define PY_SSIZE_T_CLEAN
#include "Python.h"
#include "structmember.h"
#ifndef PY_LONG_LONG
  #define PY_LONG_LONG LONG_LONG
#endif
#if PY_VERSION_HEX < 0x02050000
  typedef int Py_ssize_t;
  #define PY_SSIZE_T_MAX INT_MAX
  #define PY_SSIZE_T_MIN INT_MIN
  #define PyInt_FromSsize_t(z) PyInt_FromLong(z)
  #define PyInt_AsSsize_t(o)	PyInt_AsLong(o)
#endif
#ifndef WIN32
  #define __stdcall
  #define __cdecl
#endif
#ifdef __cplusplus
#define __PYX_EXTERN_C extern "C"
#else
#define __PYX_EXTERN_C extern
#endif
#include <math.h>
#include "Scientific/arrayobject.h"
#include "math.h"


typedef struct {PyObject **p; char *s;} __Pyx_InternTabEntry; /*proto*/
typedef struct {PyObject **p; char *s; long n;} __Pyx_StringTabEntry; /*proto*/

static PyObject *__pyx_m;
static PyObject *__pyx_b;
static int __pyx_lineno;
static char *__pyx_filename;
static char **__pyx_f;

static int __Pyx_ArgTypeTest(PyObject *obj, PyTypeObject *type, int none_allowed, char *name); /*proto*/

static PyObject *__Pyx_GetName(PyObject *dict, PyObject *name); /*proto*/

static void __Pyx_Raise(PyObject *type, PyObject *value, PyObject *tb); /*proto*/

static int __Pyx_InternStrings(__Pyx_InternTabEntry *t); /*proto*/

static int __Pyx_InitStrings(__Pyx_StringTabEntry *t); /*proto*/

static PyTypeObject *__Pyx_ImportType(char *module_name, char *class_name, long size);  /*proto*/

static PyObject *__Pyx_ImportModule(char *name); /*proto*/

static void __Pyx_AddTraceback(char *funcname); /*proto*/

/* Declarations from Scientific_interpolation */

static PyTypeObject *__pyx_ptype_24Scientific_interpolation_ArrayType = 0;


/* Implementation of Scientific_interpolation */

static PyObject *__pyx_n_ValueError;

static PyObject *__pyx_k1p;

static char __pyx_k1[] = "Point outside grid of values";

static PyObject *__pyx_f_24Scientific_interpolation__interpolate(PyObject *__pyx_self, PyObject *__pyx_args, PyObject *__pyx_kwds); /*proto*/
static PyObject *__pyx_f_24Scientific_interpolation__interpolate(PyObject *__pyx_self, PyObject *__pyx_args, PyObject *__pyx_kwds) {
  double __pyx_v_x;
  PyArrayObject *__pyx_v_axis = 0;
  PyArrayObject *__pyx_v_values = 0;
  double __pyx_v_period;
  double *__pyx_v_axis_d;
  double *__pyx_v_values_d;
  int __pyx_v_axis_s;
  int __pyx_v_values_s;
  int __pyx_v_np;
  int __pyx_v_i1;
  int __pyx_v_i2;
  int __pyx_v_i;
  double __pyx_v_w1;
  double __pyx_v_w2;
  PyObject *__pyx_r;
  int __pyx_1;
  PyObject *__pyx_2 = 0;
  PyObject *__pyx_3 = 0;
  PyObject *__pyx_4 = 0;
  static char *__pyx_argnames[] = {"x","axis","values","period",0};
  if (!PyArg_ParseTupleAndKeywords(__pyx_args, __pyx_kwds, "dOOd", __pyx_argnames, &__pyx_v_x, &__pyx_v_axis, &__pyx_v_values, &__pyx_v_period)) return 0;
  Py_INCREF(__pyx_v_axis);
  Py_INCREF(__pyx_v_values);
  if (!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_axis), __pyx_ptype_24Scientific_interpolation_ArrayType, 1, "axis")) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 12; goto __pyx_L1;}
  if (!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_values), __pyx_ptype_24Scientific_interpolation_ArrayType, 1, "values")) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 12; goto __pyx_L1;}

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":19 */
  #ifndef PYREX_WITHOUT_ASSERTIONS
  __pyx_1 = (__pyx_v_axis->descr->type_num == PyArray_DOUBLE);
  if (__pyx_1) {
    __pyx_1 = (__pyx_v_values->descr->type_num == PyArray_DOUBLE);
  }
  if (!__pyx_1) {
    PyErr_SetNone(PyExc_AssertionError);
    {__pyx_filename = __pyx_f[0]; __pyx_lineno = 19; goto __pyx_L1;}
  }
  #endif

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":21 */
  __pyx_v_np = (__pyx_v_axis->dimensions[0]);

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":22 */
  __pyx_v_axis_s = ((__pyx_v_axis->strides[0]) / (sizeof(double)));

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":23 */
  __pyx_v_axis_d = ((double *)__pyx_v_axis->data);

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":24 */
  __pyx_v_values_s = ((__pyx_v_values->strides[0]) / (sizeof(double)));

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":25 */
  __pyx_v_values_d = ((double *)__pyx_v_values->data);

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":27 */
  __pyx_1 = (__pyx_v_period > 0.);
  if (__pyx_1) {
    __pyx_v_x = ((__pyx_v_axis_d[0]) + fmod((__pyx_v_x - (__pyx_v_axis_d[0])),__pyx_v_period));
    goto __pyx_L2;
  }
  /*else*/ {
    __pyx_1 = (__pyx_v_x < ((__pyx_v_axis_d[0]) - 1.e-9));
    if (!__pyx_1) {
      __pyx_1 = (__pyx_v_x > ((__pyx_v_axis_d[((__pyx_v_np - 1) * __pyx_v_axis_s)]) + 1.e-9));
    }
    if (__pyx_1) {
      __pyx_2 = __Pyx_GetName(__pyx_b, __pyx_n_ValueError); if (!__pyx_2) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 31; goto __pyx_L1;}
      __pyx_3 = PyTuple_New(1); if (!__pyx_3) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 31; goto __pyx_L1;}
      Py_INCREF(__pyx_k1p);
      PyTuple_SET_ITEM(__pyx_3, 0, __pyx_k1p);
      __pyx_4 = PyObject_CallObject(__pyx_2, __pyx_3); if (!__pyx_4) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 31; goto __pyx_L1;}
      Py_DECREF(__pyx_2); __pyx_2 = 0;
      Py_DECREF(__pyx_3); __pyx_3 = 0;
      __Pyx_Raise(__pyx_4, 0, 0);
      Py_DECREF(__pyx_4); __pyx_4 = 0;
      {__pyx_filename = __pyx_f[0]; __pyx_lineno = 31; goto __pyx_L1;}
      goto __pyx_L3;
    }
    __pyx_L3:;
  }
  __pyx_L2:;

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":32 */
  __pyx_v_i1 = 0;

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":33 */
  __pyx_v_i2 = (__pyx_v_np - 1);

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":34 */
  while (1) {
    __pyx_1 = ((__pyx_v_i2 - __pyx_v_i1) > 1);
    if (!__pyx_1) break;

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":35 */
    __pyx_v_i = ((__pyx_v_i1 + __pyx_v_i2) / 2);

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":36 */
    __pyx_1 = ((__pyx_v_axis_d[(__pyx_v_i * __pyx_v_axis_s)]) > __pyx_v_x);
    if (__pyx_1) {
      __pyx_v_i2 = __pyx_v_i;
      goto __pyx_L6;
    }
    /*else*/ {
      __pyx_v_i1 = __pyx_v_i;
    }
    __pyx_L6:;
  }

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":40 */
  __pyx_1 = (__pyx_v_period > 0.);
  if (__pyx_1) {
    __pyx_1 = (__pyx_v_x > (__pyx_v_axis_d[(__pyx_v_i2 * __pyx_v_axis_s)]));
  }
  if (__pyx_1) {

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":41 */
    __pyx_v_i1 = (__pyx_v_np - 1);

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":42 */
    __pyx_v_i2 = 0;

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":43 */
    __pyx_v_w2 = ((__pyx_v_x - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])) / (((__pyx_v_axis_d[(__pyx_v_i2 * __pyx_v_axis_s)]) + __pyx_v_period) - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])));
    goto __pyx_L7;
  }
  __pyx_1 = (__pyx_v_period > 0.);
  if (__pyx_1) {
    __pyx_1 = (__pyx_v_x < (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)]));
  }
  if (__pyx_1) {

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":45 */
    __pyx_v_i1 = (__pyx_v_np - 1);

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":46 */
    __pyx_v_i2 = 0;

    /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":48 */
    __pyx_v_w2 = (((__pyx_v_x - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])) + __pyx_v_period) / (((__pyx_v_axis_d[(__pyx_v_i2 * __pyx_v_axis_s)]) - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])) + __pyx_v_period));
    goto __pyx_L7;
  }
  /*else*/ {
    __pyx_v_w2 = ((__pyx_v_x - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])) / ((__pyx_v_axis_d[(__pyx_v_i2 * __pyx_v_axis_s)]) - (__pyx_v_axis_d[(__pyx_v_i1 * __pyx_v_axis_s)])));
  }
  __pyx_L7:;

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":51 */
  __pyx_v_w1 = (1. - __pyx_v_w2);

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":52 */
  __pyx_2 = PyFloat_FromDouble(((__pyx_v_w1 * (__pyx_v_values_d[(__pyx_v_i1 * __pyx_v_values_s)])) + (__pyx_v_w2 * (__pyx_v_values_d[(__pyx_v_i2 * __pyx_v_values_s)])))); if (!__pyx_2) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 52; goto __pyx_L1;}
  __pyx_r = __pyx_2;
  __pyx_2 = 0;
  goto __pyx_L0;

  __pyx_r = Py_None; Py_INCREF(Py_None);
  goto __pyx_L0;
  __pyx_L1:;
  Py_XDECREF(__pyx_2);
  Py_XDECREF(__pyx_3);
  Py_XDECREF(__pyx_4);
  __Pyx_AddTraceback("Scientific_interpolation._interpolate");
  __pyx_r = 0;
  __pyx_L0:;
  Py_DECREF(__pyx_v_axis);
  Py_DECREF(__pyx_v_values);
  return __pyx_r;
}

static __Pyx_InternTabEntry __pyx_intern_tab[] = {
  {&__pyx_n_ValueError, "ValueError"},
  {0, 0}
};

static __Pyx_StringTabEntry __pyx_string_tab[] = {
  {&__pyx_k1p, __pyx_k1, sizeof(__pyx_k1)},
  {0, 0, 0}
};

static struct PyMethodDef __pyx_methods[] = {
  {"_interpolate", (PyCFunction)__pyx_f_24Scientific_interpolation__interpolate, METH_VARARGS|METH_KEYWORDS, 0},
  {0, 0, 0, 0}
};

static void __pyx_init_filenames(void); /*proto*/

PyMODINIT_FUNC initScientific_interpolation(void); /*proto*/
PyMODINIT_FUNC initScientific_interpolation(void) {
  __pyx_init_filenames();
  __pyx_m = Py_InitModule4("Scientific_interpolation", __pyx_methods, 0, 0, PYTHON_API_VERSION);
  if (!__pyx_m) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 7; goto __pyx_L1;};
  __pyx_b = PyImport_AddModule("__builtin__");
  if (!__pyx_b) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 7; goto __pyx_L1;};
  if (PyObject_SetAttrString(__pyx_m, "__builtins__", __pyx_b) < 0) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 7; goto __pyx_L1;};
  if (__Pyx_InternStrings(__pyx_intern_tab) < 0) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 7; goto __pyx_L1;};
  if (__Pyx_InitStrings(__pyx_string_tab) < 0) {__pyx_filename = __pyx_f[0]; __pyx_lineno = 7; goto __pyx_L1;};
  __pyx_ptype_24Scientific_interpolation_ArrayType = __Pyx_ImportType("Scientific.N", "ArrayType", sizeof(PyArrayObject)); if (!__pyx_ptype_24Scientific_interpolation_ArrayType) {__pyx_filename = __pyx_f[1]; __pyx_lineno = 26; goto __pyx_L1;}

  /* "../Include/Scientific/numeric.pxi":36 */
  import_array();

  /* "/Users/hinsen/Programs/ScientificPython/main/Src/Scientific_interpolation.pyx":12 */
  return;
  __pyx_L1:;
  __Pyx_AddTraceback("Scientific_interpolation");
}

static char *__pyx_filenames[] = {
  "Scientific_interpolation.pyx",
  "numeric.pxi",
};

/* Runtime support code */

static void __pyx_init_filenames(void) {
  __pyx_f = __pyx_filenames;
}

static int __Pyx_ArgTypeTest(PyObject *obj, PyTypeObject *type, int none_allowed, char *name) {
    if (!type) {
        PyErr_Format(PyExc_SystemError, "Missing type object");
        return 0;
    }
    if ((none_allowed && obj == Py_None) || PyObject_TypeCheck(obj, type))
        return 1;
    PyErr_Format(PyExc_TypeError,
        "Argument '%s' has incorrect type (expected %s, got %s)",
        name, type->tp_name, obj->ob_type->tp_name);
    return 0;
}

static PyObject *__Pyx_GetName(PyObject *dict, PyObject *name) {
    PyObject *result;
    result = PyObject_GetAttr(dict, name);
    if (!result)
        PyErr_SetObject(PyExc_NameError, name);
    return result;
}

static void __Pyx_Raise(PyObject *type, PyObject *value, PyObject *tb) {
    Py_XINCREF(type);
    Py_XINCREF(value);
    Py_XINCREF(tb);
    /* First, check the traceback argument, replacing None with NULL. */
    if (tb == Py_None) {
        Py_DECREF(tb);
        tb = 0;
    }
    else if (tb != NULL && !PyTraceBack_Check(tb)) {
        PyErr_SetString(PyExc_TypeError,
            "raise: arg 3 must be a traceback or None");
        goto raise_error;
    }
    /* Next, replace a missing value with None */
    if (value == NULL) {
        value = Py_None;
        Py_INCREF(value);
    }
    #if PY_VERSION_HEX < 0x02050000
    if (!PyClass_Check(type))
    #else
    if (!PyType_Check(type))
    #endif
    {
        /* Raising an instance.  The value should be a dummy. */
        if (value != Py_None) {
            PyErr_SetString(PyExc_TypeError,
                "instance exception may not have a separate value");
            goto raise_error;
        }
        /* Normalize to raise <class>, <instance> */
        Py_DECREF(value);
        value = type;
        #if PY_VERSION_HEX < 0x02050000
            if (PyInstance_Check(type)) {
                type = (PyObject*) ((PyInstanceObject*)type)->in_class;
                Py_INCREF(type);
            }
            else {
                PyErr_SetString(PyExc_TypeError,
                    "raise: exception must be an old-style class or instance");
                goto raise_error;
            }
        #else
            type = (PyObject*) type->ob_type;
            Py_INCREF(type);
            if (!PyType_IsSubtype((PyTypeObject *)type, (PyTypeObject *)PyExc_BaseException)) {
                PyErr_SetString(PyExc_TypeError,
                    "raise: exception class must be a subclass of BaseException");
                goto raise_error;
            }
        #endif
    }
    PyErr_Restore(type, value, tb);
    return;
raise_error:
    Py_XDECREF(value);
    Py_XDECREF(type);
    Py_XDECREF(tb);
    return;
}

static int __Pyx_InternStrings(__Pyx_InternTabEntry *t) {
    while (t->p) {
        *t->p = PyString_InternFromString(t->s);
        if (!*t->p)
            return -1;
        ++t;
    }
    return 0;
}

static int __Pyx_InitStrings(__Pyx_StringTabEntry *t) {
    while (t->p) {
        *t->p = PyString_FromStringAndSize(t->s, t->n - 1);
        if (!*t->p)
            return -1;
        ++t;
    }
    return 0;
}

static PyTypeObject *__Pyx_ImportType(char *module_name, char *class_name, 
    long size) 
{
    PyObject *py_module = 0;
    PyObject *result = 0;
    
    py_module = __Pyx_ImportModule(module_name);
    if (!py_module)
        goto bad;
    result = PyObject_GetAttrString(py_module, class_name);
    if (!result)
        goto bad;
    if (!PyType_Check(result)) {
        PyErr_Format(PyExc_TypeError, 
            "%s.%s is not a type object",
            module_name, class_name);
        goto bad;
    }
    if (((PyTypeObject *)result)->tp_basicsize != size) {
        PyErr_Format(PyExc_ValueError, 
            "%s.%s does not appear to be the correct type object",
            module_name, class_name);
        goto bad;
    }
    return (PyTypeObject *)result;
bad:
    Py_XDECREF(result);
    return 0;
}

static PyObject *__Pyx_ImportModule(char *name) {
    PyObject *py_name = 0;
    
    py_name = PyString_FromString(name);
    if (!py_name)
        goto bad;
    return PyImport_Import(py_name);
bad:
    Py_XDECREF(py_name);
    return 0;
}

#include "compile.h"
#include "frameobject.h"
#include "traceback.h"

static void __Pyx_AddTraceback(char *funcname) {
    PyObject *py_srcfile = 0;
    PyObject *py_funcname = 0;
    PyObject *py_globals = 0;
    PyObject *empty_tuple = 0;
    PyObject *empty_string = 0;
    PyCodeObject *py_code = 0;
    PyFrameObject *py_frame = 0;
    
    py_srcfile = PyString_FromString(__pyx_filename);
    if (!py_srcfile) goto bad;
    py_funcname = PyString_FromString(funcname);
    if (!py_funcname) goto bad;
    py_globals = PyModule_GetDict(__pyx_m);
    if (!py_globals) goto bad;
    empty_tuple = PyTuple_New(0);
    if (!empty_tuple) goto bad;
    empty_string = PyString_FromString("");
    if (!empty_string) goto bad;
    py_code = PyCode_New(
        0,            /*int argcount,*/
        0,            /*int nlocals,*/
        0,            /*int stacksize,*/
        0,            /*int flags,*/
        empty_string, /*PyObject *code,*/
        empty_tuple,  /*PyObject *consts,*/
        empty_tuple,  /*PyObject *names,*/
        empty_tuple,  /*PyObject *varnames,*/
        empty_tuple,  /*PyObject *freevars,*/
        empty_tuple,  /*PyObject *cellvars,*/
        py_srcfile,   /*PyObject *filename,*/
        py_funcname,  /*PyObject *name,*/
        __pyx_lineno,   /*int firstlineno,*/
        empty_string  /*PyObject *lnotab*/
    );
    if (!py_code) goto bad;
    py_frame = PyFrame_New(
        PyThreadState_Get(), /*PyThreadState *tstate,*/
        py_code,             /*PyCodeObject *code,*/
        py_globals,          /*PyObject *globals,*/
        0                    /*PyObject *locals*/
    );
    if (!py_frame) goto bad;
    py_frame->f_lineno = __pyx_lineno;
    PyTraceBack_Here(py_frame);
bad:
    Py_XDECREF(py_srcfile);
    Py_XDECREF(py_funcname);
    Py_XDECREF(empty_tuple);
    Py_XDECREF(empty_string);
    Py_XDECREF(py_code);
    Py_XDECREF(py_frame);
}
