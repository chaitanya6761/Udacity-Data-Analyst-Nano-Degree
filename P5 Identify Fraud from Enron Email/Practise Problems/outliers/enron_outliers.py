#!/usr/bin/python

import pickle
import sys
from operator import itemgetter

import matplotlib.pyplot
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit
### read in data dictionary, convert to numpy array
data_dict = pickle.load( open("../final_project/final_project_dataset.pkl", "r") )
features = ["salary", "bonus"]
data_dict.pop('TOTAL',0)
data = featureFormat(data_dict, features)
maxBonus = 0
maxBonusKey = ''
for key,item in data_dict.items():
    bonus = item["bonus"]
    if bonus > maxBonus and  bonus != 'NaN':
        maxBonus = bonus
        maxBonusKey = key

print 'Max Bonus:', maxBonus
print 'Max Bonus Key: ', maxBonusKey

salary_data=[]
for key,item in data_dict.items():
    salary = item['salary']
    if salary != 'NaN':
        salary_data.append((key, salary))

salary_data = sorted(salary_data, key=itemgetter(1), reverse=True)

print salary_data[:2]

### your code below
for point in data:
    salary = point[0]
    bonus = point[1]
    matplotlib.pyplot.scatter( salary, bonus )

matplotlib.pyplot.xlabel("salary")
matplotlib.pyplot.ylabel("bonus")
matplotlib.pyplot.show()