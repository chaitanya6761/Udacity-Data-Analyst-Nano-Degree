#!/usr/bin/python
from operator import itemgetter


def outlierCleaner(predictions, ages, net_worths):
    """
        Clean away the 10% of points that have the largest
        residual errors (difference between the prediction
        and the actual net worth).

        Return a list of tuples named cleaned_data where 
        each tuple is of the form (age, net_worth, error).
    """
    
    cleaned_data = []

    ### your code goes here
    lst = []
    for i in range(len(predictions)):
        error = (predictions[i][0] - net_worths[i][0    ])**2
        lst.append((ages[i][0], net_worths[i][0], error))

    lst = sorted(lst, key=itemgetter(2))

    newLength = int(len(lst) * 0.90)

    for i in range(newLength):
        cleaned_data.append(lst[i])

    return cleaned_data

