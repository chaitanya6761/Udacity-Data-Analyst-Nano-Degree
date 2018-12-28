##  Identify Fraud from Enron Email


**Q1. Summarize for us the goal of this project and how machine learning is useful in trying to accomplish it. As part of your answer, give some background on the dataset and how it can be used to answer the project question. Were there any outliers in the data when you got it, and how did you handle those?**

Enron corporation was an American energy, commodities and services company based in Houstan, Texas. It was founded in 1985 as an merger between Houston Natural Gas and InterNorth, both relatively small regional companies. Enron employed approximately 20,000 staff and was a major electricity, natural gas, communications and plup and paper company. By 2000, Enron with claimed revenues of nearly $101 billion was one of the largest companies in the united states but by the end of 2002, it collapsed into bankruptcy due to widespread corporate fraud. In the resulting federal investigation process, confidential information like financials of the company and emails exchanged between the employees got leaked into the public domain. So, the main goal of this project is to find persons of intrest who were responsible for Enron fraud by applying various machine learning algorithms.

There are a total of 146 points in the dataset and 18 of them are POI's.

There are 14 financial features in the dataset and all there units are in US Dollors:
- salary
- deferral_payments
- total_payments
- loan_advances
- bonus
- restricted_stock_deferred
- deferred_income
- total_stock_value
- expenses
- exercised_stock_options
- other
- long_term_incentive
- restricted_stock
- director_fees

There are 6 email features in the dataset and all their units are generally number of emails messages; notable exception is ‘email_address’, which is a text string:
- to_messages
- email_address
- from_poi_to_this_person
- from_messages
- from_this_person_to_poi
- shared_receipt_with_poi

There is one more feature which is a boolean and determines whether a data point is a POI or not:
- poi

There are two outliers in the dataset which are **'TOTAL'** and **'THE TRAVEL AGENCY IN THE PARK'**, I removed these data points from the dataset. 

By plotting each variable, I found that lot of data points have missing values which were replaced by zeros in feature formating and data points with all zeros were removed as part of feature formating.

Total number of data points after outlier removal and feature formating are : 143

**Q2. What features did you end up using in your POI identifier, and what selection process did you use to pick them? Did you have to do any scaling? Why or why not?In your feature selection step, if you used an algorithm like a decision tree, please also give the feature importances of the features that you use, and if you used an automated feature selection function like SelectKBest, please report the feature scores and reasons for your choice of parameter values.**

Following are the new features added to the dataset:

- from_this_person_to_poi_ratio : which is the ratio of from_this_person_to_poi to from_messages.
- from_poi_to_this_person_ratio : which is the ratio of from_poi_to_this_person to to_messages.
- bonus_salary_ratio : which is the ratio of bonus to salary ratio.

MinMaxScaler was used to scale the features so that algorthims which work on the basis of distance calculations doesn't get effected by the variables which have high range like salary, bonus and stock options.

SelectKBest was used to select the best features and below are thier scores:

| Features       | Scores |
| :---------------------- | -----: |
| exercised_stock_options | 24.815079733218194 |
| total_stock_value       | 24.182898678566879 |
| bonus                   | 20.792252047181535 |
| salary                  | 18.289684043404513 |
| from_this_person_to_poi_ratio         | 16.409712548035792 |
| deferred_income     |  11.458476579280369 |
| bonus_salary_ratio        |  10.783584708160824 |
| long_term_incentive        |  9.9221860131898225 |
| restricted_stock          |  9.2128106219771002 |
| total_payments |  8.7727777300916756 |
| shared_receipt_with_poi           |  8.589420731682381 |
| loan_advances | 7.1840556582887247 |
| expenses       | 6.0941733106389453 |
| from_poi_to_this_person                   | 5.2434497133749582 |
| other                  | 4.1874775069953749 |
| from_poi_to_this_person_ratio         | 3.1280917481567192 |
| from_this_person_to_poi     |  2.3826121082276739 |
| director_fees        |  2.1263278020077054 |
| to_messages          |  1.6463411294420076 |
| deferral_payments | 0.22461127473600989 |
| from_messages           |  0.16970094762175533 |
| restricted_stock_deferred           | 0.065499652909942141 |

After Getting all the scores from selectKBest, I sorted them in a decreasing order and started with top 5 features as it was a good combination of both financial and email features and continued till my model achieved maximum recall and precision values. Below table lists of metrics for various k levels:

| K | Recall | Precision | F1 Score | 
| :-| -----: |-----: | -----: |
| 5 | 0.32650 | 0.49545 | 0.39361 |
| **6** | **0.38550** | **0.51572** | **0.44120** |
| **7** | **0.38550** | **0.51572** | **0.44120** |
| 8 | 0.37950 | 0.48716 | 0.42664 |
| **9**| **0.39550** | **0.48617** | **0.43617** |
| 10 | 0.31700 | 0.38355 | 0.34711 |
| 11 | 0.31400 | 0.36639 | 0.33818 |
| 12 | 0.31150 | 0.32550 | 0.31834 |
| 13 | 0.31100 | 0.32430 | 0.31751 |
| 14 | 0.31100 | 0.32514 | 0.31791 |
| 15 | 0.31000 | 0.30437 | 0.30716 |
| 16 | 0.31000 | 0.30437 | 0.30716 |
| 17 | 0.31000 | 0.30969 | 0.30985 |
| 18 | 0.32850 | 0.24830 | 0.28282 |
| 19 | 0.30550 | 0.22979 | 0.26229 |
| 20 | 0.27050 | 0.21392 | 0.23890 |

The Above table shows that my model performed well, if the chosen number of top features were 6,7 or 9. I chose top 9 features to train my model because it was giving me the highest recall score of `0.39550`.

**Q3. What algorithm did you end up using? What other one(s) did you try? How did model performance differ between algorithms?**

I tried Gaussian Naive Bayes, Decision Tree, Random Forest and KNN algorithms.

Below are the scores of each algorithm before tuning as reported by tester.py:

| Algorithm       | Recall | Precision | F1 Score| Accuracy |
| :---------------------- | -----: |-----: |-----: | -----: |
| Gaussian Naive Bayes | 0.39550 | 0.48617 | 0.43617 | 0.85393 |
| Decision Tree        | 0.30300 | 0.31945 | 0.31101 | 0.80821 |
| Random Forest        | 0.16800 | 0.40191 | 0.23695 | 0.84543 |
| K Nearest Neighbours | 0.25900 | 0.68883 | 0.37645 | 0.87743 |

Only Gussian Naive Bayes And Decision Tree seem to achieve the limit of 0.3 for both recall and precision.

**Q4. What does it mean to tune the parameters of an algorithm, and what can happen if you don’t do this well?  How did you tune the parameters of your particular algorithm? What parameters did you tune?**

Tuning of algorithm refers to adjusting the parameters, so that we can achieve better performence. If in case parameters are not optimized properly it might result in lower accuracy. This process of tuning can also sometimes result in overfitting as well.

GridSearchCV was used to tune the parameters of the algorithms. The table below shows the performence metrics after tuning process.

The best metrics chosen for each algorithm are
- Decision Tree : {'min_samples_split': 11, 'splitter': 'random', 'criterion': 'entropy', 'max_depth': 2, 'class_weight': None}
- Random Forest : {'min_samples_split': 4, 'criterion': 'gini', 'max_depth': 7, 'class_weight': None}
- KNN : {'n_neighbors': 6, 'weights': 'uniform', 'algorithm': 'auto'}

| Algorithm       | Recall | Precision | F1 Score| Accuracy |
| :---------------------- | -----: |-----: |-----: | -----: |
| Gaussian Naive Bayes | 0.39550 | 0.48617 | 0.43617 | 0.85393 |
| Decision Tree        | 0.11650 | 0.48340 | 0.18775 | 0.85600 |
| Random Forest        | 0.19200 | 0.40506 | 0.26052 | 0.84429 |
| K Nearest Neighbours | 0.08600 | 0.99422 | 0.15831 | 0.86936 |

After tuning the parameters for the algorithms, only decision tree and random forest seem to show some improvement in metrics.

**Q5. What is validation, and what’s a classic mistake you can make if you do it wrong? How did you validate your analysis?**

Validation is the process of establishing how well our model has been trained on the dataset and how well it generalizes and performs on the test set. A classic mistake that we can make in this step is to train and test on the same data. 

We need to always have a seperate training and testing set to validate our model. Generally we use 70%-30% split to train and test our data. For the purpose of this project in poi_id.py file, data was split into 70:30 ratio for quick traing and testing.

The dataset used in this project has a imblance in lables, that's why I used tester.py's StratifiedShuffleSplit as an other alternative to test my model extensively by running tester.py which trains and tests model on multiple folds to average out the accuracy and other metrics

**Q6. Give at least 2 evaluation metrics and your average performance for each of them. Explain an interpretation of your metrics that says something human-understandable about your algorithm’s performance.**

The two evaluation metrics which were used to determine the performence are precision and recall, because accuracy alone would not be enough as our dataset has imblance in classes. The highest precison(0.48617) and recall(0.39550) scores were reported by GussianNB.

- Precision : Out all the datapoints labelled as POI'S, how many are actually POI's.
- Recall    : Out all the datapoints that are truely POI'S, how many datapoints were correctly classified as POI'S.

For this project especially, we don't want to miss any POI's, so we don't care much about the precision, instead we want our recall parameter to be high so that no POI's is left out. Even though our model may sometimes classify some non POI to be a POI but we will do further investigation on the person to actually determine his involvement in the fraud. 

### Files: 
- `Enron Dataset Exploration.ipynb` : Contains EDA of each variable of the dataset.
- `poi_id.py` : Contains code to identify the POI's from the dataset.



