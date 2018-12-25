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
