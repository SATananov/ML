# Linear Regression, Regularization and Testing in R
# Educational project covering:
# - Regression problem statement and motivation
# - Ordinary Least Squares (OLS)
# - Simulated example
# - Implementation on real data
# - RANSAC robust regression
# - Polynomial regression
# - Multi-dimensional linear regression
# - Regularization with Ridge regression
# - Model testing with MAE, RMSE and R-squared

cat("Linear Regression, Regularization and Testing in R\n")
cat("Project started.\n\n")

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

mae <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

r_squared <- function(actual, predicted) {
  1 - sum((actual - predicted)^2) / sum((actual - mean(actual))^2)
}

print_metrics <- function(actual, predicted, model_name) {
  cat("\n", model_name, "testing metrics:\n", sep = "")
  cat("MAE:", round(mae(actual, predicted), 3), "\n")
  cat("RMSE:", round(rmse(actual, predicted), 3), "\n")
  cat("R-squared:", round(r_squared(actual, predicted), 3), "\n")
}

# ------------------------------------------------------------
# 1. Regression - Problem Statement and Motivation
# ------------------------------------------------------------

cat("1. Regression - Problem Statement and Motivation\n")
cat("Goal: predict a continuous numerical value from input variables.\n")
cat("Example: predict fuel efficiency (mpg) from car characteristics.\n\n")

# ------------------------------------------------------------
# 2. OLS - Simulated Example
# ------------------------------------------------------------

cat("2. Ordinary Least Squares - Simulated Example\n")

set.seed(42)

x <- seq(1, 100)
noise <- rnorm(100, mean = 0, sd = 12)
y <- 15 + 2.5 * x + noise

simulated_data <- data.frame(x = x, y = y)

ols_simulated_model <- lm(y ~ x, data = simulated_data)

cat("\nOLS simulated model summary:\n")
print(summary(ols_simulated_model))

png("01_ols_simulated_example.png", width = 900, height = 650)

plot(
  simulated_data$x,
  simulated_data$y,
  main = "OLS on Simulated Data",
  xlab = "x",
  ylab = "y",
  pch = 19
)

abline(ols_simulated_model, lwd = 2)

dev.off()

# ------------------------------------------------------------
# 3. OLS - Implementation on Real Data
# ------------------------------------------------------------

cat("\n3. OLS - Implementation on Real Data\n")
cat("Dataset: mtcars, built into R.\n")
cat("Target: mpg. Predictor: wt.\n\n")

real_data <- mtcars

ols_real_model <- lm(mpg ~ wt, data = real_data)

cat("OLS real-data model summary:\n")
print(summary(ols_real_model))

png("02_ols_real_data_mtcars.png", width = 900, height = 650)

plot(
  real_data$wt,
  real_data$mpg,
  main = "OLS on Real Data: mtcars",
  xlab = "Car Weight",
  ylab = "Miles Per Gallon",
  pch = 19
)

abline(ols_real_model, lwd = 2)

dev.off()

# ------------------------------------------------------------
# 4. RANSAC - Robust Regression Model
# ------------------------------------------------------------

cat("\n4. RANSAC - Robust Regression Model\n")

set.seed(123)

ransac_data <- simulated_data

# Add several outliers
outlier_rows <- sample(1:nrow(ransac_data), 10)
ransac_data$y[outlier_rows] <- ransac_data$y[outlier_rows] + rnorm(10, mean = 160, sd = 25)

ordinary_model_with_outliers <- lm(y ~ x, data = ransac_data)

ransac_simple <- function(data, iterations = 200, threshold = 20) {
  best_inliers <- c()
  best_model <- NULL

  for (i in 1:iterations) {
    sample_rows <- sample(1:nrow(data), 2)
    sample_data <- data[sample_rows, ]

    temp_model <- lm(y ~ x, data = sample_data)
    temp_predictions <- predict(temp_model, data)

    residuals <- abs(data$y - temp_predictions)
    inliers <- which(residuals < threshold)

    if (length(inliers) > length(best_inliers)) {
      best_inliers <- inliers
      best_model <- lm(y ~ x, data = data[inliers, ])
    }
  }

  list(model = best_model, inliers = best_inliers)
}

ransac_result <- ransac_simple(ransac_data)
ransac_model <- ransac_result$model

cat("\nOrdinary model with outliers summary:\n")
print(summary(ordinary_model_with_outliers))

cat("\nRANSAC robust model summary:\n")
print(summary(ransac_model))

png("03_ransac_robust_regression.png", width = 900, height = 650)

plot(
  ransac_data$x,
  ransac_data$y,
  main = "RANSAC Robust Regression",
  xlab = "x",
  ylab = "y",
  pch = 19
)

abline(ordinary_model_with_outliers, lwd = 2, lty = 2)
abline(ransac_model, lwd = 2)

legend(
  "topleft",
  legend = c("OLS with outliers", "RANSAC robust model"),
  lty = c(2, 1),
  lwd = c(2, 2),
  bty = "n"
)

dev.off()

# ------------------------------------------------------------
# 5. Linear Regression Extensions
# ------------------------------------------------------------

cat("\n5. Linear Regression Extensions\n")

# 5.1 Polynomial Regression
cat("\n5.1 Polynomial Regression\n")

polynomial_model <- lm(mpg ~ wt + I(wt^2), data = real_data)

cat("Polynomial regression model summary:\n")
print(summary(polynomial_model))

png("04_polynomial_regression.png", width = 900, height = 650)

plot(
  real_data$wt,
  real_data$mpg,
  main = "Polynomial Regression: mtcars",
  xlab = "Car Weight",
  ylab = "Miles Per Gallon",
  pch = 19
)

ordered_wt <- seq(min(real_data$wt), max(real_data$wt), length.out = 100)
poly_predictions <- predict(
  polynomial_model,
  newdata = data.frame(wt = ordered_wt)
)

lines(ordered_wt, poly_predictions, lwd = 2)

dev.off()

# 5.2 Multi-Dimensional Linear Regression
cat("\n5.2 Multi-Dimensional Linear Regression\n")

multi_model <- lm(mpg ~ wt + hp + cyl, data = real_data)

cat("Multi-dimensional regression model summary:\n")
print(summary(multi_model))

# ------------------------------------------------------------
# 6. Regularization - Ridge Regression
# ------------------------------------------------------------

cat("\n6. Regularization - Ridge Regression\n")

set.seed(101)

train_index <- sample(1:nrow(real_data), size = floor(0.8 * nrow(real_data)))

train_data <- real_data[train_index, ]
test_data <- real_data[-train_index, ]

# Ordinary multi-dimensional model for comparison
ordinary_test_model <- lm(mpg ~ wt + hp + cyl, data = train_data)
ordinary_predictions <- predict(ordinary_test_model, test_data)

# Ridge regression implemented manually with matrix algebra.
# Formula:
# beta = solve(t(X) %*% X + lambda * I) %*% t(X) %*% y
# The intercept is not regularized.

ridge_regression <- function(train_data, lambda = 10) {
  x_train <- model.matrix(mpg ~ wt + hp + cyl, data = train_data)
  y_train <- train_data$mpg

  penalty <- diag(ncol(x_train))
  penalty[1, 1] <- 0

  beta <- solve(t(x_train) %*% x_train + lambda * penalty) %*% t(x_train) %*% y_train

  beta
}

ridge_predict <- function(beta, new_data) {
  x_new <- model.matrix(mpg ~ wt + hp + cyl, data = new_data)
  as.vector(x_new %*% beta)
}

lambda <- 10

ridge_beta <- ridge_regression(train_data, lambda = lambda)
ridge_predictions <- ridge_predict(ridge_beta, test_data)

cat("\nRidge coefficients with lambda =", lambda, ":\n")
print(ridge_beta)

# ------------------------------------------------------------
# 7. Model Testing
# ------------------------------------------------------------

cat("\n7. Model Testing\n")

print_metrics(
  test_data$mpg,
  ordinary_predictions,
  "Ordinary multi-dimensional linear regression"
)

print_metrics(
  test_data$mpg,
  ridge_predictions,
  "Ridge regularized regression"
)

test_results <- data.frame(
  car = rownames(test_data),
  actual_mpg = test_data$mpg,
  ordinary_prediction = round(ordinary_predictions, 2),
  ridge_prediction = round(ridge_predictions, 2)
)

cat("\nTest-set prediction comparison:\n")
print(test_results)

png("05_actual_vs_predicted_testing.png", width = 900, height = 650)

plot(
  test_data$mpg,
  ordinary_predictions,
  main = "Model Testing: Actual vs Predicted MPG",
  xlab = "Actual MPG",
  ylab = "Predicted MPG",
  pch = 19
)

points(test_data$mpg, ridge_predictions, pch = 17)

abline(0, 1, lwd = 2)

legend(
  "topleft",
  legend = c("Ordinary regression", "Ridge regression", "Perfect prediction line"),
  pch = c(19, 17, NA),
  lty = c(NA, NA, 1),
  lwd = c(NA, NA, 2),
  bty = "n"
)

dev.off()

cat("\nGenerated plots:\n")
cat("- 01_ols_simulated_example.png\n")
cat("- 02_ols_real_data_mtcars.png\n")
cat("- 03_ransac_robust_regression.png\n")
cat("- 04_polynomial_regression.png\n")
cat("- 05_actual_vs_predicted_testing.png\n")

cat("\nProject completed successfully.\n")
