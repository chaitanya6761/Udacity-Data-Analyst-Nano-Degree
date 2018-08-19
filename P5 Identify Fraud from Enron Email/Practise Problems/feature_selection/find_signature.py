#!/usr/bin/python

import pickle
import numpy
numpy.random.seed(42)


### The words (features) and authors (labels), already largely processed.
### These files should have been created from the previous (Lesson 10)
### mini-project.
words_file = "../text_learning/your_word_data.pkl" 
authors_file = "../text_learning/your_email_authors.pkl"
word_data = pickle.load( open(words_file, "r"))
authors = pickle.load( open(authors_file, "r") )



### test_size is the percentage of events assigned to the test set (the
### remainder go into training)
### feature matrices changed to dense representations for compatibility with
### classifier functions in versions 0.15.2 and earlier
from sklearn import cross_validation
features_train, features_test, labels_train, labels_test = cross_validation.train_test_split(word_data, authors, test_size=0.1, random_state=42)

from sklearn.feature_extraction.text import TfidfVectorizer
vectorizer = TfidfVectorizer(sublinear_tf=True, max_df=0.5,
                             stop_words='english')
features_train = vectorizer.fit_transform(features_train)
features_test  = vectorizer.transform(features_test).toarray()


### a classic way to overfit is to use a small number
### of data points and a large number of features;
### train on only 150 events to put ourselves in this regime
features_train = features_train[:150].toarray()
labels_train   = labels_train[:150]



### your code goes here
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
classifier = DecisionTreeClassifier()
classifier.fit(features_train, labels_train)

pred = classifier.predict(features_test)
print "Accuracy: ",accuracy_score(pred, labels_test)

max_imp_feature = 0
max_imp_feature_index = 0

features_imp = classifier.feature_importances_
names = vectorizer.get_feature_names()

print "Words With Importance Greater Than 0.2: "
for i in range(len(features_imp)):
    if features_imp[i] > 0.2:
        print names[i], features_imp[i]
    if features_imp[i] > max_imp_feature:
        max_imp_feature = features_imp[i]
        max_imp_feature_index = i

print "max_imp_feature_index: ", max_imp_feature_index
print "max_imp_feature:",max_imp_feature

print "Name Of The Imp feature: ",names[max_imp_feature_index]
