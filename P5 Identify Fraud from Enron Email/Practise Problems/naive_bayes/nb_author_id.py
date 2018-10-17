#!/usr/bin/python

""" 
    This is the code to accompany the Lesson 1 (Naive Bayes) mini-project. 

    Use a Naive Bayes Classifier to identify emails by their authors
    
    authors and labels:
    Sara has label 0
    Chris has label 1
"""
    
import sys
from time import time
sys.path.append("../tools/")
from email_preprocess import preprocess


### features_train and features_test are the features for the training
### and testing datasets, respectively
### labels_train and labels_test are the corresponding item labels
features_train, features_test, labels_train, labels_test = preprocess()

from sklearn.naive_bayes import GaussianNB,MultinomialNB

classifier = GaussianNB()
t0 = time()
classifier.fit(features_train,labels_train)
print "Training Time Of GaussianNB :",(time()-t0)

t1 = time()
classifier.predict(features_test)
print "Predicting Time Of GaussianNB",(time() - t1)

print "Accuracy Of GaussianNB",classifier.score(features_test,labels_test)

print"---------------------------------------------------------------------"


classifier = MultinomialNB()
t0 = time()
classifier.fit(features_train,labels_train)
print "Training Time Of MultinomialNB :",(time()-t0)

t1 = time()
classifier.predict(features_test)
print "Predicting Time Of MultinomialNB",(time() - t1)

print "Accuracy Of MultinomialNB",classifier.score(features_test,labels_test)
