#!/usr/bin/python

#Imports
import sys
import pickle
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit
from sklearn.metrics import recall_score, precision_score, classification_report
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.feature_selection import SelectKBest, f_classif
from tester import dump_classifier_and_data
from operator import itemgetter

from sklearn.naive_bayes import GaussianNB
from sklearn.preprocessing import MinMaxScaler
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC


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
 'from_poi_to_this_person'] # You will need to use more features


### Load the dictionary containing the dataset
with open("final_project_dataset.pkl", "r") as data_file:
    data_dict = pickle.load(data_file)

print '------------------------------------------------------'
print 'Total Number Of Data Points Before Removing Outliers: ', len(data_dict)
print 'Total Number Of Features: ', len(features_list)

### Task 2: Remove outliers
data_dict.pop('TOTAL', 0)
data_dict.pop('THE TRAVEL AGENCY IN THE PARK', 0)

###Counting Number Of POI'S
num_poi = 0
for key,value in data_dict.items():
    if value['poi'] == True:
        num_poi += 1

print "Total Number Of POI's In The Dataset: ", num_poi

### Task 3: Create new feature(s)
### Lets Create The Follwoing New Features
### from_this_person_to_poi_ratio
### from_poi_to_this_person_ratio
### salary_bonus_ratio

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


### Store to my_dataset for easy export below.
my_dataset = data_dict

###The below list of features were chosen by applying SelectKbest process
###The Top 11 features were chosen from the list for further analysis
###The selectKBest code which is below lists the importance of each feature
features_list = [
 'poi',
 'exercised_stock_options',
 'total_stock_value',
 'bonus',
 'salary',
 'from_this_person_to_poi_ratio',
 'deferred_income',
 'bonus_salary_ratio',
 'long_term_incentive',
 'restricted_stock',
#'total_payments',
#'shared_receipt_with_poi',
#'loan_advances',
#'expenses',
#'from_poi_to_this_person',
#'other',
#'from_poi_to_this_person_ratio',
#'from_this_person_to_poi',
#'director_fees',
#'to_messages',
#'deferral_payments',
#'from_messages',
#'restricted_stock_deferred'
]

### Extract features and labels from dataset for local testing
data = featureFormat(my_dataset, features_list, sort_keys = True)
labels, features = targetFeatureSplit(data)
print 'Total Number Of Data Points After Removing Outliers And Feature Formatting : ', len(features)

#Code to print importance of each feature and to select best out of them for further analysis
'''selector = SelectKBest(f_classif, k='all')
selector.fit(features, labels)
feature_importances_skb = selector.scores_
features_list_with_imp = []
for i in range(len(feature_importances_skb)):
    features_list_with_imp.append([features_list[i+1], feature_importances_skb[i]])
features_list_with_imp = sorted(features_list_with_imp, reverse=True, key=itemgetter(1))
for i in range(len(features_list_with_imp)):
    print features_list_with_imp[i]'''


#Scalling The Data Using MinMaxScaler
scaler = MinMaxScaler()
features = scaler.fit_transform(features)

#Splitting Data Into Test And Train Data
features_train, features_test, labels_train, labels_test = \
    train_test_split(features, labels, test_size=0.3, random_state=42)

### Task 4: Try a varity of classifiers
### Please name your classifier clf for easy export below.
### Note that if you want to do PCA or other multi-stage operations,
### you'll need to use Pipelines. For more info:
### http://scikit-learn.org/stable/modules/pipeline.html

# Provided to give you a starting point. Try a variety of classifiers.
### Gaussian Naive Bayes Classifier
clf = GaussianNB()

### Decision Tree Classifier
### Best Params Reported By GridSearchCV {'min_samples_split': 11, 'splitter': 'random', 'criterion': 'entropy', 'max_depth': 2, 'class_weight': None}
#clf = DecisionTreeClassifier(min_samples_split=11, splitter='random', criterion='entropy', max_depth=2, class_weight=None)
#clf = DecisionTreeClassifier()

### Random Forest Classifier
### Best Params Reported By GridSearchCV {'min_samples_split': 4, 'criterion': 'gini', 'max_depth': 7, 'class_weight': None}
#clf = RandomForestClassifier(min_samples_split=4, criterion='gini', max_depth=7, class_weight=None)

### KNeighborsClassifier
### Best Params Reported By GridSearchCV  {'n_neighbors': 6, 'weights': 'uniform', 'algorithm': 'auto'}
#clf = KNeighborsClassifier(n_neighbors=6, weights='uniform', algorithm='auto')

### Params For Tuning DecisionTree
'''params = {'criterion':['gini','entropy'],
          'max_depth':[i for i in range(2,15)],
          'min_samples_split':[i for i in range(2,15)],
          #'splitter' : ['best', 'random'],
          'class_weight' : [None, 'balanced']
         }'''

### Params For Tuning KNN
'''params = {'n_neighbors' : [i for i in range(5,20)],
          'weights': ['uniform', 'distance'],
          'algorithm':['auto', 'ball_tree', 'kd_tree', 'brute'],
          }'''


#clf = GridSearchCV(clf, params, verbose=1000)
clf.fit(features_train, labels_train)
pred = clf.predict(features_test)

###Best Params
#print clf.best_params_


### Task 5: Tune your classifier to achieve better than .3 precision and recall 
### using our testing script. Check the tester.py script in the final project
### folder for details on the evaluation method, especially the test_classifier
### function. Because of the small size of the dataset, the script uses
### stratified shuffle split cross validation. For more info: 
### http://scikit-learn.org/stable/modules/generated/sklearn.cross_validation.StratifiedShuffleSplit.html
print '------------------------------------------------------'
print 'Metrics:'
print 'Recall Score: ', recall_score(labels_test, pred)
print 'Precision Score: ', precision_score(labels_test, pred)
print classification_report(labels_test, pred)
print '------------------------------------------------------'
# Example starting point. Try investigating other evaluation techniques!
### Task 6: Dump your classifier, dataset, and features_list so anyone can
### check your results. You do not need to change anything below, but make sure
### that the version of poi_id.py that you submit can be run on its own and
### generates the necessary .pkl files for validating your results.

dump_classifier_and_data(clf, my_dataset, features_list)