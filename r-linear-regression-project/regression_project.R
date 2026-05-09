# Linear Regression Project in R
# I use the built-in mtcars dataset.
# My goal is to predict fuel efficiency based on car weight and horsepower.

data <- mtcars

cat("First rows of the dataset:\n")
print(head(data))

cat("\nCreating linear regression model...\n")

model <- lm(mpg ~ wt + hp, data = data)

cat("\nModel summary:\n")
print(summary(model))

predictions <- predict(model, data)

result <- data.frame(
  actual_mpg = data$mpg,
  predicted_mpg = round(predictions, 2)
)

cat("\nActual vs Predicted MPG:\n")
print(head(result, 10))

cat("\nProject completed successfully.\n")
# Model Testing

errors <- result$actual_mpg - result$predicted_mpg

mae <- mean(abs(errors))
rmse <- sqrt(mean(errors^2))

cat("\nModel Testing:\n")
cat("Mean Absolute Error:", round(mae, 2), "\n")
cat("Root Mean Squared Error:", round(rmse, 2), "\n")
# Train/Test Split
# I split the data into training and testing sets.
# This gives a more realistic evaluation of the model.

set.seed(123)

train_index <- sample(1:nrow(data), size = 0.8 * nrow(data))

train_data <- data[train_index, ]
test_data <- data[-train_index, ]

cat("\nTraining rows:", nrow(train_data), "\n")
cat("Testing rows:", nrow(test_data), "\n")

# Train model only on training data
test_model <- lm(mpg ~ wt + hp, data = train_data)

# Predict only on testing data
test_predictions <- predict(test_model, test_data)

test_result <- data.frame(
  car = rownames(test_data),
  actual_mpg = test_data$mpg,
  predicted_mpg = round(test_predictions, 2)
)

cat("\nTest Set Predictions:\n")
print(test_result)

# Test error
test_errors <- test_data$mpg - test_predictions

test_mae <- mean(abs(test_errors))
test_rmse <- sqrt(mean(test_errors^2))

cat("\nReal Model Testing on Test Data:\n")
cat("Test Mean Absolute Error:", round(test_mae, 2), "\n")
cat("Test Root Mean Squared Error:", round(test_rmse, 2), "\n")
# Visualizations
# I create plots to better understand the relationship between the data and the model.

png("weight_vs_mpg.png", width = 800, height = 600)

plot(data$wt, data$mpg,
     main = "Car Weight vs Fuel Efficiency",
     xlab = "Weight",
     ylab = "Miles per Gallon",
     pch = 19)

abline(lm(mpg ~ wt, data = data), lwd = 2)

dev.off()

png("actual_vs_predicted.png", width = 800, height = 600)

plot(test_data$mpg, test_predictions,
     main = "Actual vs Predicted MPG",
     xlab = "Actual MPG",
     ylab = "Predicted MPG",
     pch = 19)

abline(0, 1, lwd = 2)

dev.off()

cat("\nVisualizations saved:\n")
cat("- weight_vs_mpg.png\n")
cat("- actual_vs_predicted.png\n")

cat("\nFinal project completed successfully.\n")