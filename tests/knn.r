# suppressMessages(library(knn, quietly=TRUE))
# suppressMessages(library(class, quietly=TRUE))

set.seed(1)

train_ind = 1:25
x = rbind(
  subset(iris, Species=='setosa')[train_ind, ],
  subset(iris, Species=='versicolor')[train_ind, ],
  subset(iris, Species=='virginica')[train_ind, ]
)

test_ind = 26:50
test = rbind(
  subset(iris, Species=='setosa')[test_ind, ],
  subset(iris, Species=='versicolor')[test_ind, ],
  subset(iris, Species=='virginica')[test_ind, ]
)

x$Species = NULL
test$Species = NULL

y <- factor(c(rep("s", 25), rep("c", 25), rep("v", 25)))

k = 1
# c1 = class::knn(x, test, y, k=k, prob=FALSE)
c1 <-
structure(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 3L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 1L, 3L, 3L, 1L, 3L, 3L, 3L, 3L, 3L, 1L, 3L, 3L, 
3L, 3L, 1L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L), .Label = c("c", 
"s", "v"), class = "factor")
c2 = knn::knn(x, y, test, k=k)
stopifnot(all.equal(c1, c2))

k = 3
# c1 = class::knn(x, test, y, k=k, prob=FALSE)
c1 <-
structure(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 1L, 3L, 1L, 
1L, 1L, 1L, 1L, 3L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 1L, 3L, 1L, 1L, 3L, 3L, 3L, 3L, 3L, 1L, 3L, 3L, 
3L, 3L, 1L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L), .Label = c("c", 
"s", "v"), class = "factor")
c2 = knn::knn(x, y, test, k=k)
stopifnot(all.equal(c1, c2))
