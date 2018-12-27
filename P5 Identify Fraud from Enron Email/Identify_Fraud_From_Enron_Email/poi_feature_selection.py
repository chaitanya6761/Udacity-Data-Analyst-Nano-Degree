#!/usr/bin/python

#Imports
import sys
import pickle
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit
from sklearn.tree import DecisionTreeClassifier
from operator import itemgetter
from sklearn.feature_selection import SelectKBest, f_classif

### Task 1: Select what features you'll use.
### features_list is a list of strings, each of which is a feature name.
### The first feature must be "poi".
features_list = ['poi',
'salary',
 'to_messages',
 'deferral_payments',
 'total_payments',
 'exercised_stock_options',
 'bonus',
 'restricted_stock',
 'shared_receipt_with_poi',
 'restricted_stock_deferred',
 'total_stock_value',
 'expenses',
 'loan_advances',
 'from_messages',
  'other',
 'from_this_person_to_poi',
 'director_fees',
 'deferred_income',
 'long_term_incentive',
 'from_poi_to_this_person',
 'from_this_person_to_poi_ratio',
 'from_poi_to_this_person_ratio',
 'salary_bonus_ratio'] # You will need to use more features


### Load the dictionary containing the dataset
with open("final_project_dataset.pkl", "r") as data_file:
    data_dict = pickle.load(data_file)

### Task 2: Remove outliers
data_dict.pop('TOTAL', 0)
data_dict.pop('THE TRAVEL AGENCY IN THE PARK', 0)

### Task 3: Create new feature(s)
### Store to my_dataset for easy export below.
def calculate_ratios(val1, val2):
    result = 0
    if val1 == 'NaN' or val2 == 'NaN':
        result = 'NaN'
    else :
        result = val1/float(val2)

    return result

for key,value in data_dict.items():
    value['from_this_person_to_poi_ratio'] = calculate_ratios(value['from_this_person_to_poi'], value['from_messages'])
    value['from_poi_to_this_person_ratio'] = calculate_ratios(value['from_poi_to_this_person'], value['to_messages'])
    value['bonus_salary_ratio'] = calculate_ratios(value['bonus'], value['salary'])
    
my_dataset = data_dict

features_list = ['poi',
  'salary',
 'to_messages',
 'deferral_payments',
 'total_payments',
 'exercised_stock_options',
 'bonus',
 'restricted_stock',
 'shared_receipt_with_poi',
 'restricted_stock_deferred',
 'total_stock_value',
 'expenses',
 'loan_advances',
 'from_messages',
  'other',
 'from_this_person_to_poi',
 'director_fees',
 'deferred_income',
 'long_term_incentive',
'from_poi_to_this_person',
'from_this_person_to_poi_ratio',
 'from_poi_to_this_person_ratio',
 'bonus_salary_ratio']

### Extract features and labels from dataset for local testing
data = featureFormat(my_dataset, features_list, sort_keys = True)
labels, features = targetFeatureSplit(data)

#Lets Use DecisonTree To Extract Feature Importances
model = DecisionTreeClassifier()
model.fit(features, labels)

feature_importances_tree = model.feature_importances_
features_list_with_imp = []
for i in range(len(feature_importances_tree)):
    features_list_with_imp.append([features_list[i+1], feature_importances_tree[i]])
    
features_list_with_imp = sorted(features_list_with_imp, reverse=True, key=itemgetter(1))

for i in range(len(features_list_with_imp)):
    print features_list_with_imp[i]

print '--------------------------------------------------------------------------'

#Lets Use SelectKBest With 'all' Parameter To Extract Feature Importances
selector = SelectKBest(f_classif, k='all')
selector.fit(features, labels)

feature_importances_skb = selector.scores_
features_list_with_imp = []
for i in range(len(feature_importances_skb)):
    features_list_with_imp.append([features_list[i+1], feature_importances_skb[i]])

features_list_with_imp = sorted(features_list_with_imp, reverse=True, key=itemgetter(1))

for i in range(len(features_list_with_imp)):
    print features_list_with_imp[i]