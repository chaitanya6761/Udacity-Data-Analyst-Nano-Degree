
## Using Csv Module


```python
import csv
import os

DATADIR = ""
DATAFILE = "745090.csv"

def parse_file(datafile):
    name = None
    data = []
    with open(datafile,'r') as f:
        firstLine = f.readline()
        name = firstLine.strip().split(',')[1]
        secondLine = f.readline()
        header = csv.reader(f)
        data = (list(header))
    # Do not change the line below
    return (name.replace('"',""), data)


def test():
    datafile = os.path.join(DATADIR, DATAFILE)
    name, data = parse_file(datafile)

    assert name == "MOUNTAIN VIEW MOFFETT FLD NAS"
    assert data[0][1] == "01:00"
    assert data[2][0] == "01/01/2005"
    assert data[2][5] == "2"


if __name__ == "__main__":
    test()  
```

## Using Xlrd Module


```python
#!/usr/bin/env python
"""
Your task is as follows:
- read the provided Excel file
- find and return the min, max and average values for the COAST region
- find and return the time value for the min and max entries
- the time values should be returned as Python tuples

Please see the test function for the expected return format
"""

import xlrd
from zipfile import ZipFile
datafile = "2013_ERCOT_Hourly_Load_Data.xls"


def open_zip(datafile):
    with ZipFile('{0}.zip'.format(datafile), 'r') as myzip:
        myzip.extractall()


def parse_file(datafile):
    workbook = xlrd.open_workbook(datafile)
    sheet = workbook.sheet_by_index(0)

    ### example on how you can get the data
    #sheet_data = [[sheet.cell_value(r, col) for col in range(sheet.ncols)] for r in range(sheet.nrows)]

    ### other useful methods:
    # print "\nROWS, COLUMNS, and CELLS:"
    # print "Number of rows in the sheet:", 
    # print sheet.nrows
    # print "Type of data in cell (row 3, col 2):", 
    # print sheet.cell_type(3, 2)
    # print "Value in cell (row 3, col 2):", 
    # print sheet.cell_value(3, 2)
    # print "Get a slice of values in column 3, from rows 1-3:"
    # print sheet.col_values(3, start_rowx=1, end_rowx=4)

    # print "\nDATES:"
    # print "Type of data in cell (row 1, col 0):", 
    # print sheet.cell_type(1, 0)
    # exceltime = sheet.cell_value(1, 0)
    # print "Time in Excel format:",
    # print exceltime
    # print "Convert time to a Python datetime tuple, from the Excel float:",
    # print xlrd.xldate_as_tuple(exceltime, 0)
    
    
    col_values = sheet.col_values(1,start_rowx=1,end_rowx=None)
    
    max_val = max(col_values)
    min_val = min(col_values)
    
    max_pos = col_values.index(max_val) + 1
    min_pos = col_values.index(min_val) + 1
  
    min_time = xlrd.xldate_as_tuple(sheet.cell_value(min_pos,0), 0)
    max_time = xlrd.xldate_as_tuple(sheet.cell_value(max_pos,0), 0)
    
    data = {
            'maxtime': max_time,
            'maxvalue': max_val,
            'mintime': min_time,
            'minvalue': min_val,
            'avgcoast': sum(col_values) / float(len(col_values))
    }
    
    return data


def test():
    #open_zip(datafile)
    data = parse_file(datafile)

    assert data['maxtime'] == (2013, 8, 13, 17, 0, 0)
    assert round(data['maxvalue'], 10) == round(18779.02551, 10)


test()

parse_file(datafile)
```




    {'avgcoast': 10976.933460679751,
     'maxtime': (2013, 8, 13, 17, 0, 0),
     'maxvalue': 18779.025510000003,
     'mintime': (2013, 2, 3, 4, 0, 0),
     'minvalue': 6602.113898999982}




```python
# -*- coding: utf-8 -*-
'''
Find the time and value of max load for each of the regions
COAST, EAST, FAR_WEST, NORTH, NORTH_C, SOUTHERN, SOUTH_C, WEST
and write the result out in a csv file, using pipe character | as the delimiter.

An example output can be seen in the "example.csv" file.
'''

import xlrd
import os
import csv
from zipfile import ZipFile

datafile = "2013_ERCOT_Hourly_Load_Data.xls"
outfile = "2013_Max_Loads.csv"


def open_zip(datafile):
    with ZipFile('{0}.zip'.format(datafile), 'r') as myzip:
        myzip.extractall()


def parse_file(datafile):
    workbook = xlrd.open_workbook(datafile)
    sheet = workbook.sheet_by_index(0)
    data = []
    # YOUR CODE HERE
    # Remember that you can use xlrd.xldate_as_tuple(sometime, 0) to convert
    # Excel date to Python tuple of (year, month, day, hour, minute, second)
    
    for i in range(1,sheet.ncols-1):
        temp = {}
        temp["station_name"] = (sheet.cell_value(0,i))
        
        col_values = sheet.col_values(i,start_rowx=1,end_rowx=None)
        max_load = max(col_values)        
        max_pos = col_values.index(max_load) + 1
        max_date = xlrd.xldate_as_tuple(sheet.cell_value(max_pos,0),0)
        
        temp["max_load"] = max_load
        temp["time"] = max_date
        data.append(temp)
            
    return data
parse_file(datafile)
```




    [{'max_load': 18779.025510000003,
      'station_name': 'COAST',
      'time': (2013, 8, 13, 17, 0, 0)},
     {'max_load': 2380.1654089999956,
      'station_name': 'EAST',
      'time': (2013, 8, 5, 17, 0, 0)},
     {'max_load': 2281.2722140000024,
      'station_name': 'FAR_WEST',
      'time': (2013, 6, 26, 17, 0, 0)},
     {'max_load': 1544.7707140000005,
      'station_name': 'NORTH',
      'time': (2013, 8, 7, 17, 0, 0)},
     {'max_load': 24415.570226999993,
      'station_name': 'NORTH_C',
      'time': (2013, 8, 7, 18, 0, 0)},
     {'max_load': 5494.157645,
      'station_name': 'SOUTHERN',
      'time': (2013, 8, 8, 16, 0, 0)},
     {'max_load': 11433.30491600001,
      'station_name': 'SOUTH_C',
      'time': (2013, 8, 8, 18, 0, 0)},
     {'max_load': 1862.6137649999998,
      'station_name': 'WEST',
      'time': (2013, 8, 7, 17, 0, 0)}]




```python
data = parse_file(datafile)
def save_file(data, filename):
        with open(filename,'w') as f:
            writer = csv.writer(f, delimiter='|')
            writer.writerow(['Station','Year','Month','Day','Hour','Max Load'])
            
            for row in data:
                temp = []
                temp.append(row['station_name'])
                temp.extend(list(row['time'])[:-2])
                temp.append(row['max_load'])
                print (temp)
                writer.writerow(temp)
                        
save_file(data, "example.csv")  
```

    ['COAST', 2013, 8, 13, 17, 18779.025510000003]
    ['EAST', 2013, 8, 5, 17, 2380.1654089999956]
    ['FAR_WEST', 2013, 6, 26, 17, 2281.2722140000024]
    ['NORTH', 2013, 8, 7, 17, 1544.7707140000005]
    ['NORTH_C', 2013, 8, 7, 18, 24415.570226999993]
    ['SOUTHERN', 2013, 8, 8, 16, 5494.157645]
    ['SOUTH_C', 2013, 8, 8, 18, 11433.30491600001]
    ['WEST', 2013, 8, 7, 17, 1862.6137649999998]
    

## Using Element Tree Module


```python
#!/usr/bin/env python
# Your task here is to extract data from xml on authors of an article
# and add it to a list, one item for an author.
# See the provided data structure for the expected format.
# The tags for first name, surname and email should map directly
# to the dictionary keys
import xml.etree.ElementTree as ET

article_file = "exampleResearchArticle.xml"


def get_root(fname):
    tree = ET.parse(fname)
    return tree.getroot()


def get_authors(root):
    authors = []
    for author in root.findall('./fm/bibl/aug/au'):
        data = {
                "fnm": None,
                "snm": None,
                "email": None,
                "insr": []
        }

        # YOUR CODE HERE
        data["fnm"] = author.find('./fnm').text
        data["snm"] = author.find('./snm').text
        data["email"] = author.find('./email').text
        for child in author.findall('./insr'):
            data["insr"].append(child.attrib['iid'])
       
        authors.append(data)

    return authors


root = get_root(article_file)
get_authors(root)
```




    [{'email': 'omer@extremegate.com',
      'fnm': 'Omer',
      'insr': ['I1'],
      'snm': 'Mei-Dan'},
     {'email': 'mcarmont@hotmail.com',
      'fnm': 'Mike',
      'insr': ['I2'],
      'snm': 'Carmont'},
     {'email': 'laver17@gmail.com',
      'fnm': 'Lior',
      'insr': ['I3', 'I4'],
      'snm': 'Laver'},
     {'email': 'nyska@internet-zahav.net',
      'fnm': 'Meir',
      'insr': ['I3'],
      'snm': 'Nyska'},
     {'email': 'kammarh@gmail.com',
      'fnm': 'Hagay',
      'insr': ['I8'],
      'snm': 'Kammar'},
     {'email': 'gideon.mann.md@gmail.com',
      'fnm': 'Gideon',
      'insr': ['I3', 'I5'],
      'snm': 'Mann'},
     {'email': 'barns.nz@gmail.com',
      'fnm': 'Barnaby',
      'insr': ['I6'],
      'snm': 'Clarck'},
     {'email': 'eukots@gmail.com', 'fnm': 'Eugene', 'insr': ['I7'], 'snm': 'Kots'}]



## Using Beautiful Soup Module


```python
from bs4 import BeautifulSoup 

def options(soup,id):
    option_values = []
    carrier_list = soup.find(id=id)
    for option in carrier_list.find_all('option'):
        option_values.append(option['value'])
    return option_values

def print_list(label,codes):
    print("\n%s:" %label)
    newStr = ''
    for c in codes:
        newStr += (c) + " "
    print (newStr,"\n")
    
soup = BeautifulSoup(open("Data_Elements.html"), "lxml")
    
codes = options(soup,'CarrierList')
print_list("Carriers",codes)
    
codes = options(soup,'AirportList')
#print_list("Airports",codes)

```

    
    Carriers:
    All AllUS AllForeign AS G4 AA 5Y DL MQ EV F9 HA B6 OO WN NK UA VX  
    
    


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Please note that the function 'make_request' is provided for your reference only.
# You will not be able to to actually use it from within the Udacity web UI.
# Your task is to process the HTML using BeautifulSoup, extract the hidden
# form field values for "__EVENTVALIDATION" and "__VIEWSTATE" and set the appropriate
# values in the data dictionary.
# All your changes should be in the 'extract_data' function
from bs4 import BeautifulSoup
import requests
import json

html_page = "Data_Elements.html"


def extract_data(page):
    data = {"eventvalidation": "",
            "viewstate": ""}
    with open(page, "r") as html:
        # do something here to find the necessary values
        soup = BeautifulSoup(html,"lxml")
        data["eventvalidation"] = soup.find(id="__EVENTVALIDATION")['value']
        data["viewstate"] = soup.find(id="__VIEWSTATE")['value']
        print (data["eventvalidation"])
        print (data["viewstate"])

    return data


def make_request(data):
    eventvalidation = data["eventvalidation"]
    viewstate = data["viewstate"]

    r = requests.post("http://www.transtats.bts.gov/Data_Elements.aspx?Data=2",
                    data={'AirportList': "BOS",
                          'CarrierList': "VX",
                          'Submit': 'Submit',
                          "__EVENTTARGET": "",
                          "__EVENTARGUMENT": "",
                          "__EVENTVALIDATION": eventvalidation,
                          "__VIEWSTATE": viewstate
                    })

    return r.text

#extract_data(html_page)
```


```python
import requests
from bs4 import BeautifulSoup

s = requests.Session()
r = s.get("https://www.transtats.bts.gov/Data_Elements.aspx?Data=2")
soup = BeautifulSoup(r.text,"lxml")
viewstate_element = soup.find(id="__VIEWSTATE")
viewsate = viewstate_element['value']
eventvalidation_element = soup.find(id="__EVENTVALIDATION")
eventvalidation = eventvalidation_element['value']

r = s.post("https://www.transtats.bts.gov/Data_Elements.aspx?Data=2",data={'AirportList':"BOS",
                                                                                 'CarrierList':"VX",
                                                                                 '__EVENTTARGET':"",
                                                                                '__EVENTARGUMENT':"",
                                                                                 '__EVENTVALIDATION':eventvalidation,
                                                                                 '__VIEWSTATE':viewsate})

f = open('virgin_and_logan_airport.html',"w")
f.write(r.text)
```




    428933



#### Carrier List


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Your task in this exercise is to modify 'extract_carrier()` to get a list of
all airlines. Exclude all of the combination values like "All U.S. Carriers"
from the data that you return. You should return a list of codes for the
carriers.

All your changes should be in the 'extract_carrier()' function. The
'options.html' file in the tab above is a stripped down version of what is
actually on the website, but should provide an example of what you should get
from the full file.

Please note that the function 'make_request()' is provided for your reference
only. You will not be able to to actually use it from within the Udacity web UI.
"""

from bs4 import BeautifulSoup
html_page = "options.html"


def extract_carriers(page):
    data = []

    with open(page, "r") as html:
        # do something here to find the necessary values
        soup = BeautifulSoup(html, "lxml")
        carrier_list = soup.find(id="CarrierList")
        for option in carrier_list.find_all('option'):
            if option['value'] not in ['All','AllUS','AllForeign']:
                data.append(option['value'])
        print (len(data))
    return data


def make_request(data):
    eventvalidation = data["eventvalidation"]
    viewstate = data["viewstate"]
    airport = data["airport"]
    carrier = data["carrier"]

    r = s.post("https://www.transtats.bts.gov/Data_Elements.aspx?Data=2",
               data = (("__EVENTTARGET", ""),
                       ("__EVENTARGUMENT", ""),
                       ("__VIEWSTATE", viewstate),
                       ("__VIEWSTATEGENERATOR",viewstategenerator),
                       ("__EVENTVALIDATION", eventvalidation),
                       ("CarrierList", carrier),
                       ("AirportList", airport),
                       ("Submit", "Submit")))

    return r.text



extract_carriers(html_page)
```

    16
    




    ['FL',
     'AS',
     'AA',
     'MQ',
     '5Y',
     'DL',
     'EV',
     'F9',
     'HA',
     'B6',
     'OO',
     'WN',
     'NK',
     'US',
     'UA',
     'VX']



### Airport List


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Complete the 'extract_airports()' function so that it returns a list of airport
codes, excluding any combinations like "All".

Refer to the 'options.html' file in the tab above for a stripped down version
of what is actually on the website. The test() assertions are based on the
given file.
"""

from bs4 import BeautifulSoup
html_page = "options.html"


def extract_airports(page):
    data = []

    with open(page, "r") as html:
        # do something here to find the necessary values
        soup = BeautifulSoup(html, "lxml")
        carrier_list = soup.find(id="AirportList")
        for option in carrier_list.find_all('option'):
            if option['value'] not in ['All','AllMajors','AllOthers']:
                data.append(option['value'])
        print (len(data))
    return data



extract_airports(html_page)  
```

    15
    




    ['ATL',
     'BWI',
     'BOS',
     'CLT',
     'MDW',
     'ORD',
     'DFW',
     'DEN',
     'DTW',
     'FLL',
     'IAH',
     'LAS',
     'LAX',
     'ABR',
     'ABI']



### Processing All Files


```python
def process_file(f):
    """
    This function extracts data from the file given as the function argument in
    a list of dictionaries. This is example of the data structure you should
    return:

    data = [{"courier": "FL",
             "airport": "ATL",
             "year": 2012,
             "month": 12,
             "flights": {"domestic": 100,
                         "international": 100}
            },
            {"courier": "..."}
    ]


    Note - year, month, and the flight data should be integers.
    You should skip the rows that contain the TOTAL data for a year.
    """
    data = []
    info = {}
    info["courier"], info["airport"] = f[:6].split("-")
    # Note: create a new dictionary for each entry in the output data list.
    # If you use the info dictionary defined here each element in the list 
    # will be a reference to the same info dictionary.
    with open(f, "r") as html:
        soup = BeautifulSoup(html,"lxml")
        table_data = soup.find(id = "DataGrid1")
        for tr in table_data.find_all('tr',class_ = "dataTDRight"):
            
            temp_lst = []
            for td in tr.find_all('td'):
                temp_lst.append(td.text)
            if temp_lst[1] != "TOTAL":
                temp_dict = {}
                temp_dict["courier"] = info["courier"]
                temp_dict["airport"] = info["airport"]
                temp_dict["year"] = int(temp_lst[0])
                temp_dict["month"] = int(temp_lst[1])
                temp={}
                temp["domestic"] = int(temp_lst[2].replace(',',''))
                temp["international"] = int(temp_lst[3].replace(',',''))
                temp_dict["flights"] = temp
                data.append(temp_dict)
               
    return data

process_file("FL-ATL.html")
```




    [{'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 815489, 'international': 92565},
      'month': 10,
      'year': 2002},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 766775, 'international': 91342},
      'month': 11,
      'year': 2002},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 782175, 'international': 96881},
      'month': 12,
      'year': 2002},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 785651, 'international': 98053},
      'month': 1,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 690750, 'international': 85965},
      'month': 2,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 797634, 'international': 97929},
      'month': 3,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 766639, 'international': 89398},
      'month': 4,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 789857, 'international': 87671},
      'month': 5,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 798841, 'international': 95435},
      'month': 6,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 832075, 'international': 102795},
      'month': 7,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 831185, 'international': 102145},
      'month': 8,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 782264, 'international': 90681},
      'month': 9,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 818777, 'international': 91820},
      'month': 10,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 766266, 'international': 91004},
      'month': 11,
      'year': 2003},
     {'airport': 'ATL',
      'courier': 'FL',
      'flights': {'domestic': 798879, 'international': 97094},
      'month': 12,
      'year': 2003}]



### Splitting A File With Multiple Xmls Docs Into Multiple Files with Single Xml Doc


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# So, the problem is that the gigantic file is actually not a valid XML, because
# it has several root elements, and XML declarations.
# It is, a matter of fact, a collection of a lot of concatenated XML documents.
# So, one solution would be to split the file into separate documents,
# so that you can process the resulting files as valid XML documents.

PATENTS = 'patent.data'

def split_file(filename):
    """
    Split the input file into separate files, each containing a single patent.
    As a hint - each patent declaration starts with the same line that was
    causing the error found in the previous exercises.
    
    The new files should be saved with filename in the following format:
    "{}-{}".format(filename, n) where n is a counter, starting from 0.
    """
    count  = 0 
    with open(filename,'r') as f:
        for line in f:
            if line.startswith('<?xml') :
                fname = "{}-{}".format(filename, count)
                count  += 1
                with open(fname,'w') as f1:
                    f1.write(line)
                
split_file(PATENTS)
```

## Data Validity Problem Solve


```python
"""
Your task is to check the "productionStartYear" of the DBPedia autos datafile for valid values.
The following things should be done:
- check if the field "productionStartYear" contains a year
- check if the year is in range 1886-2014
- convert the value of the field to be just a year (not full datetime)
- the rest of the fields and values should stay the same
- if the value of the field is a valid year in the range as described above,
  write that line to the output_good file
- if the value of the field is not a valid year as described above, 
  write that line to the output_bad file
- discard rows (neither write to good nor bad) if the URI is not from dbpedia.org
- you should use the provided way of reading and writing data (DictReader and DictWriter)
  They will take care of dealing with the header.

You can write helper functions for checking the data and writing the files, but we will call only the 
'process_file' with 3 arguments (inputfile, output_good, output_bad).
"""
import csv
import pprint

INPUT_FILE = 'autos.csv'
OUTPUT_GOOD = 'autos-valid.csv'
OUTPUT_BAD = 'FIXME-autos.csv'

def process_file(input_file, output_good, output_bad):

    with open(input_file, "r") as f:
        reader = csv.DictReader(f)
        header = reader.fieldnames.
        
        good_data = []
        bad_data = []
        
        for row in reader:
            if 'dbpedia' in row['URI']:
                temp_year = row['productionStartYear']
                if temp_year is not None and temp_year != '' and temp_year != 'NULL':
                    row['productionStartYear'] = year = int(temp_year.split('-')[0])
                    if year > 1886 and year < 2014:
                        good_data.append(row)
                    else:
                        bad_data.append(row)
                else:
                    bad_data.append(row)
    
        writeToFile(output_good,good_data,header)
        writeToFile(output_bad,bad_data,header)

    
def writeToFile(filename,YOURDATA,header):
    with open(filename, "w") as g:
        writer = csv.DictWriter(g, delimiter=",", fieldnames= header)
        writer.writeheader()
        for row in YOURDATA:
            writer.writerow(row)


process_file(INPUT_FILE, OUTPUT_GOOD, OUTPUT_BAD)
```

## Problem Set : Data Quality

###  1. Auditing Data Quality


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
In this problem set you work with cities infobox data, audit it, come up with a
cleaning idea and then clean it up. In the first exercise we want you to audit
the datatypes that can be found in some particular fields in the dataset.
The possible types of values can be:
- NoneType if the value is a string "NULL" or an empty string ""
- list, if the value starts with "{"
- int, if the value can be cast to int
- float, if the value can be cast to float, but CANNOT be cast to int.
   For example, '3.23e+07' should be considered a float because it can be cast
   as float but int('3.23e+07') will throw a ValueError
- 'str', for all other values

The audit_file function should return a dictionary containing fieldnames and a 
SET of the types that can be found in the field. e.g.
{"field1": set([type(float()), type(int()), type(str())]),
 "field2": set([type(str())]),
  ....
}
The type() function returns a type object describing the argument given to the 
function. You can also use examples of objects to create type objects, e.g.
type(1.1) for a float: see the test function below for examples.

Note that the first three rows (after the header row) in the cities.csv file
are not actual data points. The contents of these rows should note be included
when processing data types. Be sure to include functionality in your code to
skip over or detect these rows.
"""
import codecs
import csv
import json
import pprint

CITIES = 'cities.csv'

FIELDS = ["name", "timeZone_label", "utcOffset", "homepage", "governmentType_label",
          "isPartOf_label", "areaCode", "populationTotal", "elevation",
          "maximumElevation", "minimumElevation", "populationDensity",
          "wgs84_pos#lat", "wgs84_pos#long", "areaLand", "areaMetro", "areaUrban"]

def isNoneType(val):
    if val == '' or val == 'NULL':
        return True
    else :
        return False
    
def isArray(val):
    if val.startswith('{'):
        return True
    else:
        return False
    
def isInt(val):
    try:
        int(val)
        return True
    except ValueError:
        return False
    
def isFloat(val):
    try:
        float(val)
        return True
    except ValueError:
        return False        

def audit_file(filename, fields):
    fieldtypes = {}
    # YOUR CODE HERE
    for val in fields:
        fieldtypes[val] = set()
    
    reader = csv.DictReader(open('cities.csv','r'))
    
    for i in range(3):
        next(reader)
    
    for row in reader:
        #print(row['areaLand'])
        for field in fields:
            if isNoneType(row[field]):
                fieldtypes[field].add(type(None))
            elif isArray(row[field]):
                fieldtypes[field].add( type([]))
            elif isInt(row[field]):
                fieldtypes[field].add(type(1))
            elif isFloat(row[field]):
                fieldtypes[field].add(type(1.1))    
            else:
                fieldtypes[field].add(type('aa')) 

    return fieldtypes

audit_file(CITIES, FIELDS)
```




    {'areaCode': {int, str, NoneType},
     'areaLand': {list, NoneType, float},
     'areaMetro': {NoneType, float},
     'areaUrban': {NoneType, float},
     'elevation': {list, NoneType, float},
     'governmentType_label': {str, NoneType},
     'homepage': {str, NoneType},
     'isPartOf_label': {list, NoneType, str},
     'maximumElevation': {NoneType},
     'minimumElevation': {NoneType},
     'name': {str, NoneType, list},
     'populationDensity': {list, NoneType, float},
     'populationTotal': {int, NoneType},
     'timeZone_label': {str, NoneType},
     'utcOffset': {int, str, NoneType, list},
     'wgs84_pos#lat': {float},
     'wgs84_pos#long': {float}}



#### 2. Fixing The Area


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
In this problem set you work with cities infobox data, audit it, come up with a
cleaning idea and then clean it up.

Since in the previous quiz you made a decision on which value to keep for the
"areaLand" field, you now know what has to be done.

Finish the function fix_area(). It will receive a string as an input, and it
has to return a float representing the value of the area or None.
You have to change the function fix_area. You can use extra functions if you
like, but changes to process_file will not be taken into account.
The rest of the code is just an example on how this function can be used.
"""
import codecs
import csv
import json
import pprint

CITIES = 'cities.csv'

def countZeros(val):
    count  = 0
    while val != 0:
        rem = val % 10
        if rem != 0:
            return count
        else:
            count  +=  1
            val = val // 10

def mostSignificant(areaList):
    
    if countZeros(areaList[0]) < countZeros(areaList[1]):
        return areaList[0]
    else:
        return areaList[1]


def fix_area(area):

    # YOUR CODE HERE
    res = None
    if area is None or area == '' or area == 'NULL' :
        return None
    elif area.startswith('{'):
        area = area.replace('{','').replace('}','').split('|')
        area = [float(val) for val in area]
        return mostSignificant(area)
    
    else :
        return float(area)

def process_file(filename):
    # CHANGES TO THIS FUNCTION WILL BE IGNORED WHEN YOU SUBMIT THE EXERCISE
    data = []

    with open(filename, "r") as f:
        reader = csv.DictReader(f)

        #skipping the extra metadata
        for i in range(3):
            next(reader)

        # processing file
        for line in reader:
            # calling your function to fix the area value
            if "areaLand" in line:
                line["areaLand"] = fix_area(line["areaLand"])
            data.append(line)

    return data


def test():
    data = process_file(CITIES)

    print("Printing three example results:")
    for n in range(9):
        pprint.pprint(data[n]["areaLand"])

if __name__ == "__main__":
    test()
```

    Printing three example results:
    None
    None
    None
    None
    None
    None
    101787000.0
    31597900.0
    55166700.0
    

### 3.Fixing Name


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
In this problem set you work with cities infobox data, audit it, come up with a
cleaning idea and then clean it up.

In the previous quiz you recognized that the "name" value can be an array (or
list in Python terms). It would make it easier to process and query the data
later if all values for the name are in a Python list, instead of being
just a string separated with special characters, like now.

Finish the function fix_name(). It will recieve a string as an input, and it
will return a list of all the names. If there is only one name, the list will
have only one item in it; if the name is "NULL", the list should be empty.
The rest of the code is just an example on how this function can be used.
"""
import codecs
import csv
import pprint

CITIES = 'cities.csv'


def fix_name(name):

    # YOUR CODE HERE
    if name == 'NULL' :
        return []
    elif name.startswith('{'):
        return name.replace('{','').replace('}','').split('|')
    else:
        return [name]


def process_file(filename):
    data = []
    with open(filename, "r") as f:
        reader = csv.DictReader(f)
        #skipping the extra metadata
        for i in range(3):
            next(reader)
        # processing file
        for line in reader:
            # calling your function to fix the area value
            if "name" in line:
                line["name"] = fix_name(line["name"])
            data.append(line)
    return data


def test():
    data = process_file(CITIES)

    print ("Printing 20 results:")
    for n in range(20):
        pprint.pprint(data[n]["name"])

    assert data[14]["name"] == ['Negtemiut', 'Nightmute']
    assert data[9]["name"] == ['Pell City Alabama']
    assert data[3]["name"] == ['Kumhari']

if __name__ == "__main__":
    test()
```

    Printing 20 results:
    ['Kud']
    ['Kuju']
    ['Kumbhraj']
    ['Kumhari']
    ['Kunigal']
    ['Kurgunta']
    ['Athens']
    ['Demopolis']
    ['Chelsea Alabama']
    ['Pell City Alabama']
    ['City of Northport']
    ['Sand Point']
    ['Unalaska Alaska']
    ['City of Menlo Park']
    ['Negtemiut', 'Nightmute']
    ['Fairbanks Alaska']
    ['Homer']
    ['Ketchikan Alaska']
    ['Nuniaq', 'Old Harbor']
    ['Rainier Washington']
    

### 4.Crossfield Auditing



```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
In this problem set you work with cities infobox data, audit it, come up with a
cleaning idea and then clean it up.

If you look at the full city data, you will notice that there are couple of
values that seem to provide the same information in different formats: "point"
seems to be the combination of "wgs84_pos#lat" and "wgs84_pos#long". However,
we do not know if that is the case and should check if they are equivalent.

Finish the function check_loc(). It will recieve 3 strings: first, the combined
value of "point" followed by the separate "wgs84_pos#" values. You have to
extract the lat and long values from the "point" argument and compare them to
the "wgs84_pos# values, returning True or False.

Note that you do not have to fix the values, only determine if they are
consistent. To fix them in this case you would need more information. Feel free
to discuss possible strategies for fixing this on the discussion forum.

The rest of the code is just an example on how this function can be used.
Changes to "process_file" function will not be taken into account for grading.
"""
import csv
import pprint

CITIES = 'cities.csv'


def check_loc(point, lat, longi):
    # YOUR CODE HERE
    point  = point.split(' ')
    if point[0] == lat and point[1] == longi:
        return True
    return False

def process_file(filename):
    data = []
    with open(filename, "r") as f:
        reader = csv.DictReader(f)
        #skipping the extra matadata
        for i in range(3):
            l = reader.next()
        # processing file
        for line in reader:
            # calling your function to check the location
            result = check_loc(line["point"], line["wgs84_pos#lat"], line["wgs84_pos#long"])
            if not result:
                print("{}: {} != {} {}".format(line["name"], line["point"], line["wgs84_pos#lat"], line["wgs84_pos#long"]))
            data.append(line)

    return data


def test():
    assert check_loc("33.08 75.28", "33.08", "75.28") == True
    assert check_loc("44.57833333333333 -91.21833333333333", "44.5783", "-91.2183") == False

if __name__ == "__main__":
    test()
```

## Establishing MongoDB Connection


```python
"""
Your task is to sucessfully run the exercise to see how pymongo works
and how easy it is to start using it.
You don't actually have to change anything in this exercise,
but you can change the city name in the add_city function if you like.

Your code will be run against a MongoDB instance that we have provided.
If you want to run this code locally on your machine,
you have to install MongoDB (see Instructor comments for link to installation information)
and uncomment the get_db function.
"""

def add_city(db):
    # Changes to this function will be reflected in the output. 
    # All other functions are for local use only.
    # Try changing the name of the city to be inserted
    db.cities.insert_one({"name" : "Chicago"})
    
def get_city(db):
    return db.cities.find_one()

def get_db():
    # For local use
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    # 'examples' here is the database name. It will be created if it does not exist.
    db = client.examples
    return db

if __name__ == "__main__":
    # For local use
    db = get_db() # uncomment this line if you want to run this locally
    add_city(db)
    print( get_city(db))
```

    {'_id': ObjectId('590dcac663c4fd06b0970b52'), 'name': 'Chicago'}
    

## Problem Set : Working With MongoDB

### 1. Preparing Data


```python
    #!/usr/bin/env python
    # -*- coding: utf-8 -*-
    """
    In this problem set you work with another type of infobox data, audit it,
    clean it, come up with a data model, insert it into MongoDB and then run some
    queries against your database. The set contains data about Arachnid class
    animals.
    
    Your task in this exercise is to parse the file, process only the fields that
    are listed in the FIELDS dictionary as keys, and return a list of dictionaries
    of cleaned values. 
    
    The following things should be done:
    - keys of the dictionary changed according to the mapping in FIELDS dictionary
    - trim out redundant description in parenthesis from the 'rdf-schema#label'
      field, like "(spider)"
    - if 'name' is "NULL" or contains non-alphanumeric characters, set it to the
      same value as 'label'.
    - if a value of a field is "NULL", convert it to None
    - if there is a value in 'synonym', it should be converted to an array (list)
      by stripping the "{}" characters and splitting the string on "|". Rest of the
      cleanup is up to you, e.g. removing "*" prefixes etc. If there is a singular
      synonym, the value should still be formatted in a list.
    - strip leading and ending whitespace from all fields, if there is any
    - the output structure should be as follows:
    
    [ { 'label': 'Argiope',
        'uri': 'http://dbpedia.org/resource/Argiope_(spider)',
        'description': 'The genus Argiope includes rather large and spectacular spiders that often ...',
        'name': 'Argiope',
        'synonym': ["One", "Two"],
        'classification': {
                          'family': 'Orb-weaver spider',
                          'class': 'Arachnid',
                          'phylum': 'Arthropod',
                          'order': 'Spider',
                          'kingdom': 'Animal',
                          'genus': None
                          }
      },
      { 'label': ... , }, ...
    ]
    
      * Note that the value associated with the classification key is a dictionary
        with taxonomic labels.
    """
    import codecs
    import csv
    import json
    import pprint
    import re
    
    DATAFILE = 'arachnid.csv'
    FIELDS ={'rdf-schema#label': 'label',
             'URI': 'uri',
             'rdf-schema#comment': 'description',
             'synonym': 'synonym',
             'name': 'name',
             'family_label': 'family',
             'class_label': 'class',
             'phylum_label': 'phylum',
             'order_label': 'order',
             'kingdom_label': 'kingdom',
             'genus_label': 'genus'}
    
    
    def process_file(filename, fields):
    
        process_fields = fields.keys()
        data = []
        with open(filename, "r") as f:
            reader = csv.DictReader(f)
            for i in range(3):
                next(reader)
    
            for line in reader:
                temp_data = {}
                
                if line["rdf-schema#label"] == 'NULL':
                    temp_data[fields['rdf-schema#label']] = None
                else :
                    temp_data[fields['rdf-schema#label']] = line["rdf-schema#label"].strip().split(' (')[0]
                    
                if line['URI'] == 'NULL':
                    temp_data[fields['URI']] = None
                else :
                    temp_data[fields['URI']] = line['URI'].strip()
                    
                if line['rdf-schema#comment'] == 'NULL':
                    temp_data[fields['rdf-schema#comment']] = None
                else :
                    temp_data[fields['rdf-schema#comment']] = line['rdf-schema#comment'].strip()
                    
                if line['name'] == 'NULL':
                    temp_data[fields['name']] = temp_data['label']
                else :
                    temp_data[fields['name']] = line['name'].strip()
                    
                if line['synonym'] == 'NULL':
                    temp_data[fields['synonym']] = None
                else :
                    temp_data[fields['synonym']] = parse_array(line['synonym'].strip())
                    
                    
                temp_class = {}
                
                if line['family_label'] == 'NULL':
                    temp_class[fields['family_label']] = None
                else :
                    temp_class[fields['family_label']] = line['family_label'].strip()
                    
                if line['class_label'] == 'NULL':
                    temp_class[fields['class_label']] = None
                else :
                    temp_class[fields['class_label']] = line['class_label'].strip()
                    
                if line['phylum_label'] == 'NULL':
                    temp_class[fields['phylum_label']] = None
                else :
                    temp_class[fields['phylum_label']] = line['phylum_label'].strip()
                    
                if line['order_label'] == 'NULL':
                    temp_class[fields['order_label']] = None
                else :
                    temp_class[fields['order_label']] = line['order_label'].strip()
                    
                    
                if line['kingdom_label'] == 'NULL':
                    temp_class[fields['kingdom_label']] = None
                else :
                    temp_class[fields['kingdom_label']] = line['kingdom_label'].strip() 
                    
                    
                if line['genus_label'] == 'NULL':
                    temp_class[fields['genus_label']] = None
                else :
                    temp_class[fields['genus_label']] = line['genus_label'].strip()     
                    
                
                temp_data['classification'] = temp_class
                
                data.append(temp_data)
                
        return data
    
    
    def parse_array(v):
        if (v[0] == "{") and (v[-1] == "}"):
            v = v.lstrip("{")
            v = v.rstrip("}")
            v_array = v.split("|")
            v_array = [i.strip().strip('*').strip() for i in v_array]
            return v_array
        return [v]
    
    
    def test():
        data = process_file(DATAFILE, FIELDS)
        print ("Your first entry:")
        pprint.pprint(data[0])
        first_entry = {
            "synonym": None, 
            "name": "Argiope", 
            "classification": {
                "kingdom": "Animal", 
                "family": "Orb-weaver spider", 
                "order": "Spider", 
                "phylum": "Arthropod", 
                "genus": None, 
                "class": "Arachnid"
            }, 
            "uri": "http://dbpedia.org/resource/Argiope_(spider)", 
            "label": "Argiope", 
            "description": "The genus Argiope includes rather large and spectacular spiders that often have a strikingly coloured abdomen. These spiders are distributed throughout the world. Most countries in tropical or temperate climates host one or more species that are similar in appearance. The etymology of the name is from a Greek name meaning silver-faced."
        }
    
        assert len(data) == 76
        assert data[0] == first_entry
        assert data[17]["name"] == "Ogdenia"
        assert data[48]["label"] == "Hydrachnidiae"
        assert data[14]["synonym"] == ["Cyrene Peckham & Peckham"]
    
    if __name__ == "__main__":
        test()
```

    Your first entry:
    {'classification': {'class': 'Arachnid',
                        'family': 'Orb-weaver spider',
                        'genus': None,
                        'kingdom': 'Animal',
                        'order': 'Spider',
                        'phylum': 'Arthropod'},
     'description': 'The genus Argiope includes rather large and spectacular '
                    'spiders that often have a strikingly coloured abdomen. These '
                    'spiders are distributed throughout the world. Most countries '
                    'in tropical or temperate climates host one or more species '
                    'that are similar in appearance. The etymology of the name is '
                    'from a Greek name meaning silver-faced.',
     'label': 'Argiope',
     'name': 'Argiope',
     'synonym': None,
     'uri': 'http://dbpedia.org/resource/Argiope_(spider)'}
    

## Inserting Into DB:


```python
"""
Complete the insert_data function to insert the data into MongoDB.
"""

import json

def insert_data(data, db):

    # Your code here. Insert the data into a collection 'arachnid'

    for val in data:
        db.arachnid.insert_one(val)
    
if __name__ == "__main__":
    
    from pymongo import MongoClient
    client = MongoClient("mongodb://localhost:27017")
    db = client.examples

    with open('arachnid.json') as f:
        data = json.loads(f.read())
        insert_data(data, db)
        pprint.pprint(db.arachnid.find_one())
```

    {'_id': ObjectId('5910b43b63c4fd20c069efe8'),
     'classification': {'class': 'Arachnid',
                        'family': 'Orb-weaver spider',
                        'genus': None,
                        'kingdom': 'Animal',
                        'order': 'Spider',
                        'phylum': 'Arthropod'},
     'description': 'The genus Argiope includes rather large and spectacular '
                    'spiders that often have a strikingly coloured abdomen. These '
                    'spiders are distributed throughout the world. Most countries '
                    'in tropical or temperate climates host one or more species '
                    'that are similar in appearance. The etymology of the name is '
                    'from a Greek name meaning silver-faced.',
     'label': 'Argiope',
     'name': 'Argiope',
     'synonym': None,
     'uri': 'http://dbpedia.org/resource/Argiope_(spider)'}
    

## Problem Set : Analyzing Data
###  1. Most Common City Name


```python
#!/usr/bin/env python
"""
Use an aggregation query to answer the following question. 

What is the most common city name in our cities collection?

Your first attempt probably identified None as the most frequently occurring
city name. What that actually means is that there are a number of cities
without a name field at all. It's strange that such documents would exist in
this collection and, depending on your situation, might actually warrant
further cleaning. 

To solve this problem the right way, we should really ignore cities that don't
have a name specified. As a hint ask yourself what pipeline operator allows us
to simply filter input? How do we test for the existence of a field?

Please modify only the 'make_pipeline' function so that it creates and returns
an aggregation pipeline that can be passed to the MongoDB aggregate function.
As in our examples in this lesson, the aggregation pipeline should be a list of
one or more dictionary objects. Please review the lesson examples if you are
unsure of the syntax.

Your code will be run against a MongoDB instance that we have provided. If you
want to run this code locally on your machine, you have to install MongoDB, 
download and insert the dataset. For instructions related to MongoDB setup and
datasets please see Course Materials.

Please note that the dataset you are using here is a different version of the
cities collection provided in the course materials. If you attempt some of the
same queries that we look at in the problem set, your results may be different.
"""

def get_db(db_name):
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    db = client[db_name]
    return db

def make_pipeline():
    # complete the aggregation pipeline
    pipeline = [{"$match":{"name":{"$exists":1}}},
                {"$group":{"_id":"$name","count":{"$sum":1}}},
                {"$sort":{"count":-1}},
                {"$limit":1}]
    return pipeline

def aggregate(db, pipeline):
    return [doc for doc in db.cities.aggregate(pipeline)]


if __name__ == '__main__':
    # The following statements will be used to test your code by the grader.
    # Any modifications to the code past this point will not be reflected by
    # the Test Run.
    db = get_db('examples')
    pipeline = make_pipeline()
    result = aggregate(db, pipeline)
    import pprint
    pprint.pprint(result[0])
    assert len(result) == 1
    assert result[0] == {'_id': 'Shahpur', 'count': 6}
```

### 2. Region Cities


```python
#!/usr/bin/env python
"""
Use an aggregation query to answer the following question. 

Which Region in India has the largest number of cities with longitude between
75 and 80?

Please modify only the 'make_pipeline' function so that it creates and returns
an aggregation pipeline that can be passed to the MongoDB aggregate function.
As in our examples in this lesson, the aggregation pipeline should be a list of
one or more dictionary objects. Please review the lesson examples if you are
unsure of the syntax.

Your code will be run against a MongoDB instance that we have provided. If you
want to run this code locally on your machine, you have to install MongoDB,
download and insert the dataset. For instructions related to MongoDB setup and
datasets please see Course Materials.

Please note that the dataset you are using here is a different version of the
cities collection provided in the course materials. If you attempt some of the
same queries that we look at in the problem set, your results may be different.
"""

def get_db(db_name):
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    db = client[db_name]
    return db

def make_pipeline():
    # complete the aggregation pipeline
    pipeline = [{"$match":{"country":"India","lon":{"$gt":75,"$lt":80}}},
                {"$unwind":"$isPartOf"},
                {"$group":{"_id":"$isPartOf",
                            "count":{"$sum":1}}},
                {"$sort":{"count":-1}},
                {"$limit":1}]
    return pipeline

def aggregate(db, pipeline):
    return [doc for doc in db.cities.aggregate(pipeline)]

if __name__ == '__main__':
    # The following statements will be used to test your code by the grader.
    # Any modifications to the code past this point will not be reflected by
    # the Test Run.
    db = get_db('examples')
    pipeline = make_pipeline()
    result = aggregate(db, pipeline)
    import pprint
    pprint.pprint(result[0])
    assert len(result) == 1
    assert result[0]["_id"] == 'Tamil Nadu'
    assert result[0]["count"] == 424
```

### 3. Average Population


```python
#!/usr/bin/env python
"""
Use an aggregation query to answer the following question. 

Extrapolating from an earlier exercise in this lesson, find the average
regional city population for all countries in the cities collection. What we
are asking here is that you first calculate the average city population for each
region in a country and then calculate the average of all the regional averages
for a country.
  As a hint, _id fields in group stages need not be single values. They can
also be compound keys (documents composed of multiple fields). You will use the
same aggregation operator in more than one stage in writing this aggregation
query. I encourage you to write it one stage at a time and test after writing
each stage.

Please modify only the 'make_pipeline' function so that it creates and returns
an aggregation  pipeline that can be passed to the MongoDB aggregate function.
As in our examples in this lesson, the aggregation pipeline should be a list of
one or more dictionary objects. Please review the lesson examples if you are
unsure of the syntax.

Your code will be run against a MongoDB instance that we have provided. If you
want to run this code locally on your machine, you have to install MongoDB,
download and insert the dataset. For instructions related to MongoDB setup and
datasets please see Course Materials.

Please note that the dataset you are using here is a different version of the
cities collection provided in the course materials. If you attempt some of the
same queries that we look at in the problem set, your results may be different.
"""

def get_db(db_name):
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    db = client[db_name]
    return db

def make_pipeline():
    # complete the aggregation pipeline
    pipeline = [{"$unwind":"$isPartOf"},
                {"$group":{"_id":{"country":"$country","region":"$isPartOf"},
                            "avg_pop":{"$avg":"$population"}}},
                {"$group":{"_id":"$_id.country",
                            "avgRegionalPopulation":{"$avg":"$avg_pop"}}}]
    return pipeline

def aggregate(db, pipeline):
    return [doc for doc in db.cities.aggregate(pipeline)]

if __name__ == '__main__':
    # The following statements will be used to test your code by the grader.
    # Any modifications to the code past this point will not be reflected by
    # the Test Run.
    db = get_db('examples')
    pipeline = make_pipeline()
    result = aggregate(db, pipeline)
    import pprint
    if len(result) < 150:
        pprint.pprint(result)
    else:
        pprint.pprint(result[:100])
    key_pop = 0
    for country in result:
        if country["_id"] == 'Lithuania':
            assert country["_id"] == 'Lithuania'
            assert abs(country["avgRegionalPopulation"] - 14750.784447977203) < 1e-10
            key_pop = country["avgRegionalPopulation"]
    assert {'_id': 'Lithuania', 'avgRegionalPopulation': key_pop} in result

```

### 3. Average population


```python
#!/usr/bin/env python
"""
Use an aggregation query to answer the following question. 

Extrapolating from an earlier exercise in this lesson, find the average
regional city population for all countries in the cities collection. What we
are asking here is that you first calculate the average city population for each
region in a country and then calculate the average of all the regional averages
for a country.
  As a hint, _id fields in group stages need not be single values. They can
also be compound keys (documents composed of multiple fields). You will use the
same aggregation operator in more than one stage in writing this aggregation
query. I encourage you to write it one stage at a time and test after writing
each stage.

Please modify only the 'make_pipeline' function so that it creates and returns
an aggregation  pipeline that can be passed to the MongoDB aggregate function.
As in our examples in this lesson, the aggregation pipeline should be a list of
one or more dictionary objects. Please review the lesson examples if you are
unsure of the syntax.

Your code will be run against a MongoDB instance that we have provided. If you
want to run this code locally on your machine, you have to install MongoDB,
download and insert the dataset. For instructions related to MongoDB setup and
datasets please see Course Materials.

Please note that the dataset you are using here is a different version of the
cities collection provided in the course materials. If you attempt some of the
same queries that we look at in the problem set, your results may be different.
"""

def get_db(db_name):
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    db = client[db_name]
    return db

def make_pipeline():
    # complete the aggregation pipeline
    pipeline = [{"$unwind":"$isPartOf"},
                {"$group":{"_id":{"country":"$country","region":"$isPartOf"},
                            "avg_pop":{"$avg":"$population"}}},
                {"$group":{"_id":"$_id.country",
                            "avgRegionalPopulation":{"$avg":"$avg_pop"}}}]
    return pipeline

def aggregate(db, pipeline):
    return [doc for doc in db.cities.aggregate(pipeline)]

if __name__ == '__main__':
    # The following statements will be used to test your code by the grader.
    # Any modifications to the code past this point will not be reflected by
    # the Test Run.
    db = get_db('examples')
    pipeline = make_pipeline()
    result = aggregate(db, pipeline)
    import pprint
    if len(result) < 150:
        pprint.pprint(result)
    else:
        pprint.pprint(result[:100])
    key_pop = 0
    for country in result:
        if country["_id"] == 'Lithuania':
            assert country["_id"] == 'Lithuania'
            assert abs(country["avgRegionalPopulation"] - 14750.784447977203) < 1e-10
            key_pop = country["avgRegionalPopulation"]
    assert {'_id': 'Lithuania', 'avgRegionalPopulation': key_pop} in result

```

## Case Study Practise Problems:

### 1. Iterative Parsing


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Your task is to use the iterative parsing to process the map file and
find out not only what tags are there, but also how many, to get the
feeling on how much of which data you can expect to have in the map.
Fill out the count_tags function. It should return a dictionary with the 
tag name as the key and number of times this tag can be encountered in 
the map as value.

Note that your code will be tested with a different data file than the 'example.osm'
"""
import xml.etree.cElementTree as ET
import pprint

def count_tags(filename):
        # YOUR CODE HERE
        tags = {}
        f = open(filename,'r')
        for event,elem in ET.iterparse(f):
            if elem.tag in tags:
                tags[elem.tag] += 1 
            else:
                tags[elem.tag] = 1
                

        return tags
        
def test():

    tags = count_tags('example.osm')
    pprint.pprint(tags)
    assert tags == {'bounds': 1,
                     'member': 3,
                     'nd': 4,
                     'node': 20,
                     'osm': 1,
                     'relation': 1,
                     'tag': 7,
                     'way': 1}

    

if __name__ == "__main__":
    test()
```

    {'bounds': 1,
     'member': 3,
     'nd': 4,
     'node': 20,
     'osm': 1,
     'relation': 1,
     'tag': 7,
     'way': 1}
    

### 2. Tag Types


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import xml.etree.cElementTree as ET
import pprint
import re
"""
Your task is to explore the data a bit more.
Before you process the data and add it into your database, you should check the
"k" value for each "<tag>" and see if there are any potential problems.

We have provided you with 3 regular expressions to check for certain patterns
in the tags. As we saw in the quiz earlier, we would like to change the data
model and expand the "addr:street" type of keys to a dictionary like this:
{"address": {"street": "Some value"}}
So, we have to see if we have such tags, and if we have any tags with
problematic characters.

Please complete the function 'key_type', such that we have a count of each of
four tag categories in a dictionary:
  "lower", for tags that contain only lowercase letters and are valid,
  "lower_colon", for otherwise valid tags with a colon in their names,
  "problemchars", for tags with problematic characters, and
  "other", for other tags that do not fall into the other three categories.
See the 'process_map' and 'test' functions for examples of the expected format.
"""


lower = re.compile(r'^([a-z]|_)*$')
lower_colon = re.compile(r'^([a-z]|_)*:([a-z]|_)*$')
problemchars = re.compile(r'[=\+/&<>;\'"\?%#$@\,\. \t\r\n]')


def key_type(element, keys):
    if element.tag == "tag":
        # YOUR CODE HERE
        tag_k_value = element.attrib['k']
        match_lower = re.search(lower,tag_k_value)
        match_lower_colon = re.search(lower_colon,tag_k_value)
        match_problemchars  = re.search(problemchars,tag_k_value)
        
        if match_lower :
            keys['lower'] += 1
            
        elif match_lower_colon :
            keys['lower_colon'] += 1
            
        elif match_problemchars:
            keys['problemchars'] += 1
        else :
            keys['other'] += 1
            
    return keys



def process_map(filename):
    keys = {"lower": 0, "lower_colon": 0, "problemchars": 0, "other": 0}
    for _, element in ET.iterparse(filename):
        keys = key_type(element, keys)

    return keys



def test():
    # You can use another testfile 'map.osm' to look at your solution
    # Note that the assertion below will be incorrect then.
    # Note as well that the test function here is only used in the Test Run;
    # when you submit, your code will be checked against a different dataset.
    keys = process_map('example_tag_types.osm')
    pprint.pprint(keys)
    assert keys == {'lower': 5, 'lower_colon': 0, 'other': 1, 'problemchars': 1}


if __name__ == "__main__":
    test()
```

    {'lower': 5, 'lower_colon': 0, 'other': 1, 'problemchars': 1}
    

### 3.Exploring Users


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import xml.etree.cElementTree as ET
import pprint
import re
"""
Your task is to explore the data a bit more.
The first task is a fun one - find out how many unique users
have contributed to the map in this particular area!

The function process_map should return a set of unique user IDs ("uid")
"""

def get_user(element):
    return


def process_map(filename):
    users = set()
    for _, element in ET.iterparse(filename):
        if element.tag == 'node' or element.tag == 'way' or element.tag == 'relation':
            users.add(element.attrib['user'])

    return users


def test():

    users = process_map('example.osm')
    pprint.pprint(users)
    assert len(users) == 6



if __name__ == "__main__":
    test()
```

    {'Umbugbene', 'fredr', 'linuxUser16', 'bbmiller', 'uboot', 'woodpeck_fixbot'}
    

### 4. Improving Street Names


```python
"""
Your task in this exercise has two steps:

- audit the OSMFILE and change the variable 'mapping' to reflect the changes needed to fix 
    the unexpected street types to the appropriate ones in the expected list.
    You have to add mappings only for the actual problems you find in this OSMFILE,
    not a generalized solution, since that may and will depend on the particular area you are auditing.
- write the update_name function, to actually fix the street name.
    The function takes a string with street name as an argument and should return the fixed name
    We have provided a simple test so that you see what exactly is expected
"""
import xml.etree.cElementTree as ET
from collections import defaultdict
import re
import pprint

OSMFILE = "example_street_types.osm"
street_type_re = re.compile(r'\b\S+\.?$', re.IGNORECASE)


expected = ["Street", "Avenue", "Boulevard", "Drive", "Court", "Place", "Square", "Lane", "Road", 
            "Trail", "Parkway", "Commons"]

# UPDATE THIS VARIABLE
mapping = { "St": "Street",
            "St.": "Street",
           "Rd.":"Road",
           "Ave":"Avenue"
            }


def audit_street_type(street_types, street_name):
    m = street_type_re.search(street_name)
    if m:
        street_type = m.group()
        if street_type not in expected:
            street_types[street_type].add(street_name)


def is_street_name(elem):
    return (elem.attrib['k'] == "addr:street")


def audit(osmfile):
    osm_file = open(osmfile, "r")
    street_types = defaultdict(set)
    for event, elem in ET.iterparse(osm_file, events=("start",)):

        if elem.tag == "node" or elem.tag == "way":
            for tag in elem.iter("tag"):
                if is_street_name(tag):
                    audit_street_type(street_types, tag.attrib['v'])
    osm_file.close()
    return street_types


def update_name(name, mapping):

    match = re.search(street_type_re,name)
    
    if match:
        val = match.group()
        name = name.replace(val,mapping[val])

    return name


def test():
    st_types = audit(OSMFILE)
    assert len(st_types) == 3
    pprint.pprint(dict(st_types))

    '''for st_type, ways in st_types.iteritems():
        for name in ways:
            better_name = update_name(name, mapping)
            print (name, "=>", better_name)
            if name == "West Lexington St.":
                assert better_name == "West Lexington Street"
            if name == "Baldwin Rd.":
                assert better_name == "Baldwin Road"
'''    

if __name__ == '__main__':
    test()
```

    {'Ave': {'N. Lincoln Ave', 'North Lincoln Ave'},
     'Rd.': {'Baldwin Rd.'},
     'St.': {'West Lexington St.'}}
    
