#' knn
#' 
#' k-nearest neighbors.
#' 
#' @details
#' At the moment, ties are resolved by choosing the smallest index.  I may
#' eventually implement a better one (say random voting).
#' 
#' The implementation is cache-aware and uses threads, and should be reasonably
#' fast.
#' 
#' @param x
#' The training data, stored as a numeric matrix or dataframe.
#' @param y
#' Labels for the training data, stored as an integer or factor.
#' @param test
#' New data to be classified.  Must have the same number of columns as the input
#' \code{x}.
#' @param k
#' The eponymous 'k', i.e., the number of voters involved in classification.
#' 
#' @return
#' The classified labels of 
#' 
#' @examples
#' \dontrun{
#' train_ind = 1:25
#' x = rbind(
#'   subset(iris, Species=='setosa')[train_ind, ],
#'   subset(iris, Species=='versicolor')[train_ind, ],
#'   subset(iris, Species=='virginica')[train_ind, ]
#' )
#' 
#' test_ind = 26:50
#' test = rbind(
#'   subset(iris, Species=='setosa')[test_ind, ],
#'   subset(iris, Species=='versicolor')[test_ind, ],
#'   subset(iris, Species=='virginica')[test_ind, ]
#' )
#' 
#' x$Species = NULL
#' test$Species = NULL
#' 
#' y <- factor(c(rep("s", 25), rep("c", 25), rep("v", 25)))
#' 
#' k = 3
#' knn::knn(train, cl, test, k=k)
#' }
#' 
#' @export
knn = function(x, y, test, k=1)
{
  if (!is.matrix(x) && !is.data.frame(x))
    stop("input 'x' must be a matrix or dataframe")
  else if (!is.matrix(x))
    x = as.matrix(x)
  
  if (!is.matrix(test) && !is.data.frame(test))
    stop("input 'test' must be a matrix or dataframe")
  else if (!is.matrix(test))
    test = as.matrix(test)
  
  if (nrow(x) != length(y))
    stop("number of observations in 'x' inconsistent with number of labels 'y'")
  if (ncol(x) != ncol(test))
    stop("number of features in 'x' inconsistent with number of features in 'y'")
  
  if (is.factor(y))
  {
    y.wasfactor = TRUE
    y.levels = levels(y)
    y = as.integer(y)
  }
  else
    y.wasfactor = FALSE
  
  if (!is.atomic(y) || !is.vector(y))
    stop("'y' must be a vector of labels")
  
  if (!is.double(x))
    storage.mode(x) = "double"
  if (!is.double(test))
    storage.mode(test) = "double"
  if (!is.integer(y))
    storage.mode(y) = "integer"
  
  k = as.integer(k)
  
  ret = .Call(R_knn, x, y, test, k)
  if (isTRUE(y.wasfactor))
    ret = factor(y.levels[ret], levels=y.levels)
  
  ret
}
