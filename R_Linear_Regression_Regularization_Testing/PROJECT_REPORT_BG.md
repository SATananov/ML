# Linear Regression, Regularization and Testing — R проект

## Идея на проекта

В този проект използвах езика R, за да демонстрирам основни техники за регресия, regularization и model testing. Целта ми беше да покажа как един регресионен модел може да предсказва числова стойност, как се обучава чрез Ordinary Least Squares, как се тества и как може да се направи по-устойчив чрез RANSAC и regularization.

## 1. Regression — Problem Statement and Motivation

Регресията се използва, когато искам да предвидя числова стойност. Пример за такава задача е предсказване на `mpg` — разход/ефективност на автомобил — според характеристики като тегло, мощност и брой цилиндри.

## 2. Ordinary Least Squares — Method and Simulated Example

Първо създадох симулирани данни, където има линейна зависимост между `x` и `y`. След това използвах функцията `lm()` в R, за да обуча Ordinary Least Squares модел. OLS намира такава линия, която минимизира сумата от квадратите на грешките между реалните и предвидените стойности.

## 3. Implementation on Real Data

След симулирания пример използвах реален вграден dataset в R — `mtcars`. Целта беше да предвидя `mpg` според теглото на автомобила (`wt`). Това показва как същият подход се прилага върху реални таблични данни.

## 4. RANSAC — Robust Regression Model

Добавих outliers към симулираните данни, за да покажа проблем при обикновената линейна регресия. След това направих проста RANSAC имплементация. RANSAC избира най-добрия модел, като търси inliers и намалява влиянието на екстремни стойности.

## 5. Linear Regression Extensions

В проекта включих две разширения:

- Polynomial Regression — добавих квадратичен term `I(wt^2)`, за да позволя на модела да улови нелинейна зависимост.
- Multi-Dimensional Linear Regression — използвах повече от една входна променлива: `wt`, `hp` и `cyl`.

## 6. Regularization

За regularization използвах Ridge Regression. Имплементирах Ridge ръчно чрез matrix algebra, без външни R packages. Ridge добавя penalty към коефициентите и помага моделът да бъде по-стабилен, особено когато има повече features или риск от overfitting.

## 7. Model Testing

Разделих данните на training и testing част. След това сравних ordinary regression и ridge regression чрез:

- MAE — Mean Absolute Error
- RMSE — Root Mean Squared Error
- R-squared

Така проверих не само дали моделът работи върху training data, а и как се представя върху test data.

## Output файлове

Скриптът създава следните графики:

1. `01_ols_simulated_example.png`
2. `02_ols_real_data_mtcars.png`
3. `03_ransac_robust_regression.png`
4. `04_polynomial_regression.png`
5. `05_actual_vs_predicted_testing.png`

## Заключение

С този R проект показах пълен процес за regression analysis: от problem statement, през OLS и реални данни, до robust regression, polynomial/multi-dimensional regression, regularization и model testing.
