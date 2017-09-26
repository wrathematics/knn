set.seed(1234)

m = 100000
n = 500
x = rbind(
  matrix(rnorm(m/2*n), ncol=n),
  matrix(rnorm(m/2*n, mean=10), ncol=n)
)
y = c(rep(1L, m/2), rep(2L, m/2))
perm = sample(m)
x = x[perm, ]
y = y[perm]

test = rbind(
  matrix(rnorm(3*n), ncol=n),
  matrix(rnorm(2*n, mean=10), ncol=n),
  matrix(rnorm(15*n), ncol=n),
  matrix(rnorm(10*n, mean=10), ncol=n)
)


t1 = system.time(m1 <- class::knn1(train=x, cl=y, test=test))
t2 = system.time(m2 <- knn::knn(x, y, test))

t1
t2
t1[3]/t2[3]

all.equal(as.integer(m1), m2)
