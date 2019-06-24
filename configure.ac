AC_PREREQ([2.69])
AC_INIT(DESCRIPTION)

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`

AC_PROG_CC_C99

AC_OPENMP
if test -n "${OPENMP_CFLAGS}"; then
  OMPFLAGS_C="\$(SHLIB_OPENMP_CFLAGS)"
else
  OMPFLAGS_C=""
fi


AC_SUBST(OMPFLAGS_C)
AC_OUTPUT(src/Makevars)
