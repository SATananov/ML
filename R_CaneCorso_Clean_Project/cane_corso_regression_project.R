# Cane Corso Linear Regression Project in R
# I use example Cane Corso data to build a simple regression model.
# My goal is to predict Cane Corso weight based on age, height, chest size and food amount.
# This is an educational machine learning project, not veterinary advice.

cat("Cane Corso regression project started.\n")

dogs <- data.frame(
  name = c(
    "Marcus", "Brutos", "Hera", "Blue", "Ares", "Nero", "Thor", "Luna",
    "Titan", "Bella", "Rocco", "Athena", "Maximus", "Kara", "Apollo",
    "Freya", "Caesar", "Maya", "Dante", "Nova"
  ),
  age_months = c(
    4, 4, 6, 7, 10, 12, 16, 18,
    24, 28, 36, 40, 44, 48, 52,
    56, 60, 64, 68, 72
  ),
  height_cm = c(
    50, 51, 55, 58, 63, 65, 68, 63,
    70, 64, 71, 65, 72, 66, 72,
    66, 73, 67, 73, 67
  ),
  chest_cm = c(
    64, 65, 70, 75, 84, 88, 94, 86,
    98, 88, 100, 90, 101, 91, 102,
    92, 103, 93, 104, 94
  ),
  food_g = c(
    570, 590, 680, 760, 880, 920, 1050, 900,
    1100, 930, 1120, 950, 1130, 960, 1140,
    970, 1150, 980, 1160, 990
  ),
  weight_kg = c(
    24, 25, 31, 36, 45, 48, 57, 49,
    63, 51, 66, 53, 67, 54, 68,
    55, 69, 56, 70, 57
  )
)

cat("\nDataset preview:\n")
print(head(dogs, 10))

set.seed(123)

train_size <- floor(0.8 * nrow(dogs))
train_index <- sample(1:nrow(dogs), size = train_size)

train_data <- dogs[train_index, ]
test_data <- dogs[-train_index, ]

cat("\nTraining rows:", nrow(train_data), "\n")
cat("Testing rows:", nrow(test_data), "\n")

model <- lm(
  weight_kg ~ age_months + height_cm + chest_cm + food_g,
  data = train_data
)

cat("\nModel summary:\n")
print(summary(model))

predictions <- predict(model, test_data)

result <- data.frame(
  dog_name = test_data[["name"]],
  actual_weight_kg = test_data[["weight_kg"]],
  predicted_weight_kg = round(predictions, 2)
)

cat("\nActual vs Predicted Cane Corso Weight:\n")
print(result)

errors <- test_data[["weight_kg"]] - predictions

mae <- mean(abs(errors))
rmse <- sqrt(mean(errors^2))

cat("\nModel Testing:\n")
cat("Mean Absolute Error:", round(mae, 2), "kg\n")
cat("Root Mean Squared Error:", round(rmse, 2), "kg\n")

new_dog <- data.frame(
  age_months = 4,
  height_cm = 50,
  chest_cm = 64,
  food_g = 570
)

prediction <- predict(model, new_dog)

cat("\nExample prediction:\n")
cat(
  "Predicted weight for a 4-month-old Cane Corso like Marcus:",
  round(prediction, 2),
  "kg\n"
)

png("cane_corso_age_vs_weight.png", width = 800, height = 600)

plot(
  dogs[["age_months"]],
  dogs[["weight_kg"]],
  main = "Cane Corso Age vs Weight",
  xlab = "Age in Months",
  ylab = "Weight in KG",
  pch = 19
)

abline(lm(weight_kg ~ age_months, data = dogs), lwd = 2)

dev.off()

png("cane_corso_actual_vs_predicted.png", width = 800, height = 600)

plot(
  test_data[["weight_kg"]],
  predictions,
  main = "Actual vs Predicted Cane Corso Weight",
  xlab = "Actual Weight KG",
  ylab = "Predicted Weight KG",
  pch = 19
)

abline(0, 1, lwd = 2)

dev.off()

cat("\nVisualizations saved:\n")
cat("- cane_corso_age_vs_weight.png\n")
cat("- cane_corso_actual_vs_predicted.png\n")

cat("\nCane Corso regression project completed successfully.\n")
