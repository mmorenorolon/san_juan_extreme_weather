set.seed(123)

n <- 200
year   <- seq(1, 200)
nao    <- rnorm(n, 0, 1)
enso   <- rnorm(n, 0, 1)
sst    <- rnorm(n, 0, 1)

# true parameter values
beta0 <- 2
beta1 <- -0.3
beta2 <- 0.2
beta3 <- 0.1
beta4 <- 0.01

# linear predictor
eta <- beta0 + beta1*nao + beta2*enso + beta3*sst + beta4*year

# mean response
mu <- exp(eta)

# simulate NB counts
extreme_events <- rnbinom(n, size = 1, mu = mu)

sim_data <- data.frame(extreme_events, nao, enso, sst, year)
