/* Automatically generated. Do not edit by hand. */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <stdlib.h>

extern SEXP R_knn(SEXP x_, SEXP y_, SEXP test_, SEXP k_);

static const R_CallMethodDef CallEntries[] = {
  {"R_knn", (DL_FUNC) &R_knn, 4},
  {NULL, NULL, 0}
};

void R_init_coop(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
