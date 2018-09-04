#!/usr/bin/python


"""
    Starter code for the evaluation mini-project.
    Start by copying your trained/tested POI identifier from
    that which you built in the validation mini-project.

    This is the second step toward building your POI identifier!

    Start by loading/formatting the data...
"""

import pickle
import sys
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit

data_dict = pickle.load(open("../final_project/final_project_dataset.pkl", "r") )

### add more features to features_list!
features_list = ["poi", "salary"]

data = featureFormat(data_dict, features_list)
labels, features = targetFeatureSplit(data)



### your code goes here 


from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.model_selection import train_test_split

features_train, features_test, labels_train, labels_test = train_test_split(features, labels, random_state=42,test_size=0.30)

clf = DecisionTreeClassifier()
clf.fit(features_train,labels_train)
pred = clf.predict(features_test)

print "Total number of people in test set:", len(labels_test)
print "How many poi's are there in the testset: ",sum(labels_test)

true_pos = 0
for i in range(len(pred)):
    if pred[i] == labels_test[i] and labels_test[i] == 1.0:
        true_pos += 1

print "Total number of true positives: ", true_pos

print "Recall Score: ", precision_score(pred,labels_test)

print 'Accuracy Score: ',accuracy_score(pred,labels_test)