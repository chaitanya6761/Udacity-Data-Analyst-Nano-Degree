#!/usr/bin/python

import os
import pickle
import re
import sys

sys.path.append( "../tools/" )
from parse_out_email_text import parseOutText

"""
    Starter code to process the emails from Sara and Chris to extract
    the features and get the documents ready for classification.

    The list of all the emails from Sara are in the from_sara list
    likewise for emails from Chris (from_chris)

    The actual documents are in the Enron email dataset, which
    you downloaded/unpacked in Part 0 of the first mini-project. If you have
    not obtained the Enron email corpus, run startup.py in the tools folder.

    The data is stored in lists and packed away in pickle files at the end.
"""


from_sara  = open("from_sara.txt", "r")
from_chris = open("from_chris.txt", "r")

from_data = []
word_data = []

### temp_counter is a way to speed up the development--there are
### thousands of emails from Sara and Chris, so running over all of them
### can take a long time
### temp_counter helps you only look at the first 200 emails in the list so you
### can iterate your modifications quicker
temp_counter = 0


for name, from_person in [("sara", from_sara), ("chris", from_chris)]:
    for path in from_person:
        ### only look at first 200 emails when developing
        ### once everything is working, remove this line to run over full dataset
        temp_counter += 1
        if temp_counter < 500000:
            path = os.path.join('..', path[:-1])
            print path
            try:
                email = open(path, "r")

            ### use parseOutText to extract the text from the opened email
                parsedText = parseOutText(email)

            ### use str.replace() to remove any instances of the words
            ### ["sara", "shackleton", "chris", "germani"]
                parsedText = parsedText.replace("sara","")
                parsedText = parsedText.replace("shackleton", "")
                parsedText = parsedText.replace("chris", "")
                parsedText = parsedText.replace("germani", "")
            ### append the text to word_data

                word_data.append(parsedText)

            ### append a 0 to from_data if email is from Sara, and 1 if email is from Chris
                if name == 'sara':
                    from_data.append(0)
                elif name == 'chris':
                    from_data.append(1)

                email.close()
            except :
                print 'File Error: ',path

print word_data[152]

print "emails processed"
from_sara.close()
from_chris.close()

pickle.dump( word_data, open("your_word_data.pkl", "w") )
pickle.dump( from_data, open("your_email_authors.pkl", "w") )



#You can access the mapping between words and feature numbers using get_feature_names(),
# which returns a list of all the words in the vocabulary. How many words are there?

### in Part 4, do TfIdf vectorization here
from sklearn.feature_extraction.text import TfidfVectorizer
vectorizer = TfidfVectorizer(stop_words='english', lowercase=True)
vectorizer.fit_transform(word_data)

feature_names = vectorizer.get_feature_names()

print len(feature_names)

print feature_names[34597]