#!/usr/bin/python

""" 
    Starter code for exploring the Enron dataset (emails + finances);
    loads up the dataset (pickled dict of dicts).

    The dataset has the form:
    enron_data["LASTNAME FIRSTNAME MIDDLEINITIAL"] = { features_dict }

    {features_dict} is a dictionary of features associated with that person.
    You should explore features_dict as part of the mini-project,
    but here's an example to get you started:

    enron_data["SKILLING JEFFREY K"]["bonus"] = 5600000
    
"""

import pickle

enron_data = pickle.load(open("../final_project/final_project_dataset.pkl", "r"))

print('Total Number Of Data Points: ',len(enron_data))

print('Number Of Features For Each Person: ',len(enron_data['ALLEN PHILLIP K']))

poiCount = 0
for key,val in enron_data.items():
    if val["poi"] :
        poiCount += 1

print("Total Number Of POI's: ", poiCount)

print('Total Value oF The Stock Belonging To James Prentice: ',enron_data['PRENTICE JAMES']['total_stock_value'])

print('How Many Email Messages Do We Have From Wesley Colwell To Persons oF Interest:',enron_data['COLWELL WESLEY']['from_this_person_to_poi'])

print('Whats the value of stock options exercised by Jeffrey K Skilling',enron_data['SKILLING JEFFREY K']['exercised_stock_options'])

print('Of These Three Individuals Lay, Skilling And Fastow, Who Took Home The Most Money Largest Value Of Total_Payments Feature:',enron_data['LAY KENNETH L']['total_payments'])

#How many folks in this dataset have a quantified salary? What about a known email address?
salaryCount = 0
emailCount = 0

for key,val in enron_data.items():
    if val['salary'] != 'NaN':
        salaryCount += 1
    if val['email_address'] != 'NaN':
        emailCount += 1

print('emailCount: ',emailCount)
print('salaryCount: ',salaryCount)


def countNaN(key):
    count = 0
    for _,value in enron_data.items():
        if value[key] == 'NaN':
            count += 1

    return count

print('Total Payments NaN: ',countNaN('total_payments'))

count = 0
for key,val in enron_data.items():
    if val["poi"] and val['total_payments'] == 'NaN':
        count += 1

print("Total Poi's Earnings NaN: ", count/float(poiCount))
