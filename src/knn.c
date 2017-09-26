#if (defined(__GNUC__) && !defined(__clang__) && !defined(__INTEL_COMPILER))
#pragma GCC push_options
#pragma GCC optimize ("unroll-loops")
#endif


#include <R.h>
#include <Rinternals.h>

#include "safeomp.h"
#include "types.h"

#define MIN(a,b) ((a)<(b)?(a):(b))
#define FREE(ptr) if(ptr!=NULL) free(ptr)


typedef struct
{
  int k;
  double *restrict dists;
  int *restrict labels;
} voters_t;


static inline void classify_get_dists(cint m, cint n, cdbl_r x, cdbl_r test_obs, dbl_r dists)
{
  memset(dists, 0, m*sizeof(*dists));
  
  #pragma omp parallel for if(m*n>OMP_MIN_SIZE)
  for (int j=0; j<n; j++)
  {
    SAFE_SIMD
    for (int i=0; i<m; i++)
    {
      const double tmp = x[i + m*j] - test_obs[j];
      dists[i] += tmp*tmp;
    }
  }
}



static inline int classify_single1(cint m, cint n, cdbl_r x, cint_r y, cdbl_r test_obs, dbl_r dists)
{
  classify_get_dists(m, n, x, test_obs, dists);
  
  double min = dists[0];
  int group = y[0];
  
  for (int i=1; i<m; i++)
  {
    if (dists[i] < min)
    {
      min = dists[i];
      group = y[i];
    }
  }
 
  return group;
}



// assume x[1]:x[len-1] are sorted largest to smallest
static inline void max2min_sort(const int len, double *const restrict x, int *const restrict y)
{
  for (int i=0; i<=len; i++)
  {
    if (i == len || x[i] < x[0])
    {
      for (int j=1; j<i; j++)
      {
        double xtmp = x[j];
        x[j] = x[j-1];
        x[j-1] = xtmp;
        
        int ytmp = y[j];
        y[j] = y[j-1];
        y[j-1] = ytmp;
      }
      
      return;
    }
  }
}



// TODO for now, ties are resolved by the smallest group number
static inline int vote(voters_t *const restrict voters)
{
  const int k = voters->k;
  double *const restrict tally = voters->dists;
  int *const restrict votes = voters->labels;
  int group;
  
  memset(tally, 0, k*sizeof(tally));
  SAFE_FOR_SIMD
  for (int i=0; i<k; i++)
    tally[votes[i]-1] += 1.0;
  
  group = 0;
  
  for (int i=1; i<k; i++)
  {
    if (tally[i] > tally[group])
      group = i;
  }
  
  return group+1;
}



static inline int classify_single(voters_t *const restrict voters, cint m, cint n, cdbl_r x, cint_r y, cdbl_r test_obs, dbl_r dists)
{
  const int k = voters->k;
  
  classify_get_dists(m, n, x, test_obs, dists);
  
  // get voters and vote
  SAFE_FOR_SIMD
  for (int i=0; i<k; i++)
  {
    voters->dists[i] = dists[i];
    voters->labels[i] = y[i];
  }
  
  for (int i=k; i<m; i++)
  {
    if (dists[i] < voters->dists[0])
    {
      voters->dists[0] = dists[i];
      voters->labels[0] = y[i];
      max2min_sort(k, voters->dists, voters->labels);
    }
  }
  
  return vote(voters);
}



SEXP R_knn(SEXP x_, SEXP y_, SEXP test_, SEXP k_)
{
  SEXP ret;
  cdbl_r x = REAL(x_);
  cint_r y = INTEGER(y_);
  cdbl_r test = REAL(test_);
  
  cint m = nrows(x_);
  cint n = ncols(x_);
  cint mtest = nrows(test_);
  cint k = INTEGER(k_)[0];
  
  PROTECT(ret = allocVector(INTSXP, mtest));
  int_r ret_pt = INTEGER(ret);
  
  double *dists = malloc(m * sizeof(*dists));
  double *test_obs = malloc(n*sizeof(*test_obs));
  if (dists == NULL || test_obs == NULL)
  {
    FREE(dists);
    FREE(test_obs);
    error("OOM");
  }
  
  if (k == 1)
  {
    for (int b=0; b<mtest; b++)
    {
      for (int j=0; j<n; j++)
        test_obs[j] = (test+b)[j*mtest];
      
      ret_pt[b] = classify_single1(m, n, x, y, test_obs, dists);
    }
  }
  else
  {
    voters_t voters;
    double *mindists = malloc(k * sizeof(*mindists));
    int *mindists_labels = malloc(k * sizeof(*mindists_labels));
    if (mindists == NULL || mindists_labels == NULL)
    {
      FREE(mindists);
      FREE(mindists_labels);
      FREE(dists);
      FREE(test_obs);
      error("OOM");
    }
    
    voters.k = k;
    voters.dists = mindists;
    voters.labels = mindists_labels;
    
    for (int b=0; b<mtest; b++)
    {
      for (int j=0; j<n; j++)
        test_obs[j] = (test+b)[j*mtest];
      
      ret_pt[b] = classify_single(&voters, m, n, x, y, test_obs, dists);
    }
    
    free(mindists);
    free(mindists_labels);
  }
  
  free(dists);
  free(test_obs);
  UNPROTECT(1);
  return ret;
}
