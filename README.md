# knn

* **Version:** 0.1-0
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/knn.png)](https://travis-ci.org/wrathematics/knn)
* **License:** [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt


Fast, multi-threaded knn.



## Installation

<!-- To install the R package, run:

```r
install.packages("coop")
``` -->

The development version is maintained on GitHub, and can easily be installed by any of the packages that offer installations from GitHub:

```r
### Pick your preference
devtools::install_github("wrathematics/knn")
ghit::install_github("wrathematics/knn")
remotes::install_github("wrathematics/knn")
```



## Benchmarks

The data consists of a random 100000x500 matrix (381.470 MiB) with 2 classes and 30 test observations.  The full script is located in `inst/benchmarks/knn.r` of the source tree of the package.


```r
t1 = system.time(m1 <- class::knn(train=x, cl=y, test=test, k=k))
t1
##   user  system elapsed 
## 7.920   0.136   8.064 

t2 = system.time(m2 <- knn::knn(x, y, test, k=k))
t1
##   user  system elapsed 
## 2.592   0.000   0.694 

t1[3]/t2[3]
## 11.6196 

all.equal(as.integer(m1), m2)
## [1] TRUE
```

All benchmarks were performed on:

* R 3.4.1
* OpenBLAS
* gcc 7.0.1
* 4 cores of a Core i5-2500K CPU @ 3.30GHz
