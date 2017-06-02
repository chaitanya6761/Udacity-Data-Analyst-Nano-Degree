
# OpenStreetMapData Case Study

**Author : Chaitanya Madala**

**Date : May 15, 2016**

## Map Area

[Ahmedabad, Gujarat, India](https://en.wikipedia.org/wiki/Ahmedabad)

[DataSet](https://mapzen.com/data/metro-extracts/metro/ahmedabad_india/) : This Dataset which is extracted from website openstreetmap contains information about the city Ahmedabad, India

## Data Auditing
- As part of data auditing plan lets find out what are the different types of tags present in our data set, but also how many, to get the feeling on how much of which data we can expect to have in the map.

- Below are required imports and constants which will be used throught the project.


```python
import xml.etree.cElementTree as ET
from collections import defaultdict
import pymongo
import subprocess
import pprint
import codecs
import json
import re
import os

INPUT_FILENAME = 'ahmedabad_india1.osm'
OUTPUT_DIR = 'Output_Data'
CURR_DIR = os.getcwd()+'\\'

if OUTPUT_DIR not in os.listdir(CURR_DIR):
    os.makedirs(CURR_DIR + OUTPUT_DIR)
```


```python
def count_tags(filename): 
   
    '''This function is written to count no of 
       different tags present in the given dataset'''
    
    dict_tags = {}
    for event,element in ET.iterparse(filename):
        tag = element.tag
        if tag in dict_tags:
            dict_tags[tag] += 1
        else:
            dict_tags[tag] = 1
            
    return dict_tags

tags = count_tags(INPUT_FILENAME)
print(tags)
```

    {'bounds': 1, 'tag': 98131, 'node': 546085, 'nd': 634041, 'way': 81271, 'member': 2291, 'relation': 511, 'osm': 1}
    

- Now lets find out how many different users contributed to this Ahemdabad openstreetmap dataset. 


```python
def count_users(filename):
    
    '''This function is written to countthe number of distinct 
    users who contributed to the Ahemdabad Openstreetmap data'''
    
    users_set = set()
    for event,element in ET.iterparse(filename):
        tag = element.tag
        if tag == 'node' or tag == 'relation' or tag == 'way':
             users_set.add(element.attrib['user'])
        element.clear()        
    return users_set

users = count_users(INPUT_FILENAME)
print('Number of users contributed: ',len(users))
```

    Number of users contributed:  354
    

- Before we procees the data and add it into our database, we should check "k" value for each tag and see if there are any potential problems


```python
lower = re.compile(r'^([a-z]|_)*$')
lower_colon = re.compile(r'^([a-z]|_)*:([a-z]|_)*$')
problemchars = re.compile(r'[=\+/&<>();\'"?%#$@\,\. \t\r\n]')

problem_chars_set = set()
others_set = set()

def key_type(element, keys):
    '''This function is defined to categorize different "k" values'''
    if element.tag == "tag":
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
            problem_chars_set.add(tag_k_value)
        else :
            keys['other'] += 1
            others_set.add(tag_k_value)
            
    return keys

def process_tags(filename):
    keys = {"lower": 0, "lower_colon": 0, "problemchars": 0, "other": 0}
    for event,element in ET.iterparse(filename):
        keys = key_type(element, keys)

    return keys

process_tags(INPUT_FILENAME)
```




    {'lower': 96127, 'lower_colon': 1962, 'other': 35, 'problemchars': 7}



- The above data shows that there are 35 other category tags and 7 problem char tags. Now lets take a look at these problemchars tags and other category tags to identify those tags, which might be useful for database insertion.


```python
print(problem_chars_set)
```

    {'famous for', 'average rate/kg'}
    


```python
print(others_set)
```

    {'source_1', 'name_1', 'mtb:scale:uphill', 'currency:INR', 'source_2', 'naptan:CommonName', 'Business', 'FIXME', 'AND_a_c', 'FID_1', 'AND_a_nosr_p', 'fuel:octane_80', 'fuel:octane_92', 'IR:zone', 'is_in:iso_3166_2', 'fuel:octane_91', 'mtb:scale:imba', 'plant:output:electricity', 'name_2'}
    

- From the above listed tags, we can discard all of them except for "famous for" tag, as it has some meaningfull data associated with it i.e, it has the value of famous dish of that particular place or resturant. 

- Now lets find out what all different "k" values are present in the data set.


```python
def process_tags_k_val(filename):
    '''This function is written to find out 
    different k values present in dataset'''
    tags_k_values_dict = {}
    final_list = list(others_set) + list(problem_chars_set)
    for event,element in ET.iterparse(filename):
        if element.tag == 'tag' :
            tag_k = element.attrib['k']
            if tag_k not in final_list:
                if tag_k not in tags_k_values_dict:
                    tags_k_values_dict[tag_k] = 1
                else :
                    tags_k_values_dict[tag_k] += 1
                
    return tags_k_values_dict

tags = process_tags_k_val(INPUT_FILENAME)
print("Length of k values dictionary: ",len(tags))
```

    Length of k values dictionary:  203
    

- As the length of dictionary is 203, the output will be huge, So I writing it to a external file called **"tags.txt" **.


```python
def output_data(lst,func=None,filename=None):
    '''This function is written to write output 
    data to a file or show it on console'''
    if filename != None:
        filename = os.path.join(CURR_DIR+OUTPUT_DIR,filename)
        
        with open(filename,'w',encoding="utf-8") as f:
            if func != None:
                for val in lst:
                    f.write("{0} ----> {1}\n".format(val,func(val)))
            else:
                if type(lst) == type({}):
                    for val in sorted(lst.keys()):
                        f.write("{0} ----> {1}\n".format(val,lst[val]))
                else:   
                    for val in lst:
                        f.write("{0}\n".format(val))
    else : 
        if func != None:
            for val in lst:
                print("{0} ----> {1}".format(val,func(val)))
        else :
            for val in lst:
                print("{0}".format(val))    
```


```python
output_data(tags,filename="tags.txt")            
```

## Problems Encountered In Postal Codes

- Now lets take a look at different postal codes present in the dataset to validate them against correct format of Ahemdabad postal codes.
- This [[website]](http://www.mapsofindia.com/pincode/india/gujarat/ahmedabad/) lists out all the available postal codes of Ahemdabad, whcih are of the format **(38\*\*\*\*)** and are 6 digits in length.
- When we take a look at different "k" value tags present in "tags.txt", we find that postal codes are defined under **"addr:postcode","postal_code"**.   


```python
correct_postal_code_set = set()
incorrect_postal_code_set = set()

def validate_postal_code(code):
    '''This function is written to validate 
    postal code aganist regular expression'''
    validate_postal_code = re.compile(r'^38(\d{4})$') #regular expression to validate postal codes.
    match = re.search(validate_postal_code,code)
    return match
    
def process_postal_codes(filename):
    for event,element in ET.iterparse(filename):
        if element.tag == 'tag':
            tag_k = element.attrib['k']
            if tag_k in ['addr:postcode','postal_code']:
                tag_v = element.attrib['v'].replace(' ','')
                
                match = validate_postal_code(tag_v)
                if match :
                    correct_postal_code_set.add(tag_v)
                else:
                    incorrect_postal_code_set.add(tag_v)
                                        
process_postal_codes(INPUT_FILENAME)                        
```


```python
print(sorted(correct_postal_code_set))
```

    ['380001', '380003', '380004', '380005', '380006', '380007', '380008', '380009', '380013', '380014', '380015', '380021', '380023', '380024', '380026', '380027', '380028', '380043', '380051', '380052', '380054', '380055', '380058', '380059', '380061', '380063', '382006', '382007', '382009', '382110', '382210', '382325', '382345', '382350', '382405', '382418', '382421', '382424', '382440', '382445', '382475', '382480', '382481']
    


```python
incorrect_postal_code_set
```




    {'3', '33026', '3800013'}



##  Problems Encountered in City Names

- Almost all the postal codes the satisfy the regular expression, we assumed, except the above listed 3 postal codes. We might need to exempt them from database insertion as they are incorrect and doesn't have the correct format.

- Now lets take a look at values present in **"addr:city"** tag, to check whether city name has been mentioned correctly in every city tag. 


```python
def process_tags(filename,par_tag):
    '''This function is written to process tags with specific "k" value.'''
    tag_data_set = set()
    for event,element in ET.iterparse(filename):
        if element.tag == "tag":
            tag_k = element.attrib['k']
            if tag_k == par_tag:
                tag_data_set.add(element.attrib['v'])
    return tag_data_set

def process_tags_dict(filename,par_tag):
    '''This function is written to process tags with specific "k" value.'''
    tag_data_set = {}
    for event,element in ET.iterparse(filename):
        if element.tag == "tag":
            tag_k = element.attrib['k']
            tag_v = element.attrib['v']
            if tag_k == par_tag:
                if tag_v not in tag_data_set:
                    tag_data_set[tag_v] = 1
                else :
                    tag_data_set[tag_v] += 1
    return tag_data_set
                    
city_names = sorted(process_tags(INPUT_FILENAME,"addr:city"))
print(city_names)
```

    ['AHEMEDABAD', 'AHMEDABAD', 'Adalaj', 'Adalaj, Gandhinagar', 'Ahemdabad', 'Ahemedabad', 'Ahmadabad', 'Ahmedabad', 'Ahmedabad, Gujarat. India', 'Ahmedabad, Prahladnagar', 'Gandhinagar', 'Khodiyar', 'Koteshwar ,Ahmedabad', 'Maninagar', 'Naroda', 'Naroda road', 'Nava naroda', 'Nr.Vatva GIDC', 'Pembroke Pines', 'Ranip', 'Thaltej', 'ahmedabad', 'kOTARPUR ,Ahemedabad', 'medabad', 'ramdevnagar', 'ranip', 'sanand', 'अहमदाबाद, गुजरात']
    

- The observations that can be drawn from the above listed city name are:
  1. **"Ahmedabad"** is mispelled in various forms like **["AHEMEDABAD", "Ahemedabad", "Ahemdabad", "Ahmadabad"].**
  2. Instead of directly mentioning the city name, it is mentioned with either some local area or with state name like **["Ahmedabad,Gujarat. India", "Ahmedabad,Prahladnagar", "Koteshwar,Ahmedabad", "kOTARPUR,Ahemedabad"].**
  3. Instead of mentioning the city name, some local area is mention in city tag like **["Khodiyar","Maninagar","Naroda","Naroda road","Nava naroda","Nr.Vatva GIDC","Pembroke Pines","Ranip","medabad","ramdevnagar"].**
  4. City name is mentioned in local language **Hindi** like **["अहमदाबाद, गुजरात"].**
  5. As Ahmedabad is situated near by Gandhinagar, some of the city tags has city value as **["Gandhinagar", "Adalaj, Gandhinagar", "Adalaj"].** 
  
- Now lets write a function that would written correct value of city which would be useful for processing city names at time of database insertion.


```python
def rectify_city_name(city_name):
    '''This function is written to rectify a given city name'''
    validate_city_ahmedabad = re.compile(r'Ah(.)*daba(d|d\,)',re.IGNORECASE)
    validate_city_gandhinagar = re.compile(r'(gandhinaga(r|r\,))|(Adalaj)',re.IGNORECASE)
    result = None
    if re.search(validate_city_ahmedabad,city_name):
        result = "Ahmedabad"
    elif re.search(validate_city_gandhinagar,city_name):
        result = "Gandhinagar"
    else :
        result = "Ahmedabad"
     
    return result
```


```python
output_data(city_names,func=rectify_city_name)
```

    AHEMEDABAD ----> Ahmedabad
    AHMEDABAD ----> Ahmedabad
    Adalaj ----> Gandhinagar
    Adalaj, Gandhinagar ----> Gandhinagar
    Ahemdabad ----> Ahmedabad
    Ahemedabad ----> Ahmedabad
    Ahmadabad ----> Ahmedabad
    Ahmedabad ----> Ahmedabad
    Ahmedabad, Gujarat. India ----> Ahmedabad
    Ahmedabad, Prahladnagar ----> Ahmedabad
    Gandhinagar ----> Gandhinagar
    Khodiyar ----> Ahmedabad
    Koteshwar ,Ahmedabad ----> Ahmedabad
    Maninagar ----> Ahmedabad
    Naroda ----> Ahmedabad
    Naroda road ----> Ahmedabad
    Nava naroda ----> Ahmedabad
    Nr.Vatva GIDC ----> Ahmedabad
    Pembroke Pines ----> Ahmedabad
    Ranip ----> Ahmedabad
    Thaltej ----> Ahmedabad
    ahmedabad ----> Ahmedabad
    kOTARPUR ,Ahemedabad ----> Ahmedabad
    medabad ----> Ahmedabad
    ramdevnagar ----> Ahmedabad
    ranip ----> Ahmedabad
    sanand ----> Ahmedabad
    अहमदाबाद, गुजरात ----> Ahmedabad
    

## Problems Encountered In Phone Numbers

- Now lets take look at values present in **"phone"** tag to check whether they are correct format or not


```python
phone_numbers = process_tags(INPUT_FILENAME,"phone")
print(phone_numbers)
```

    {'07925500007', '07926582130', '079 6619 0201', '+91 79 30912345', '9375776800', '07922912990', '+91 8758637922', '+917922167530', '+91 79 6651 5151', '+917801949128', '+91 9054876866', '+917965469992', '079 26920057', '07927641100', '+91 79 25556767', '079 2687 2386', '+919099958936', '+91 79 2657 7621', '7926620059', '07926304000', '0792740 0228', '+917927550875', '+917923224006', '093270 38242', '+917927472043', '+91 79 2646 6464', '+917927506819', '917926314000', '+91 93776 19151', '+91 79 2550 7181', '099099 22239', '+91 79 2657 5741', '855-553-4767', '+917922700585', '+91 79 3983 0100 ', '079 4050 5050', '91-79-26401554', '(079)39830036/37', '7096805450', '07922720605', '+91 79 6190 0500/05/06/07/08/09', '+917922864345', '+91 98250 41132', '+91-9978113275 ; +91-8390740897', '+91 79 29705588', '09016861000', '+919375565533', '+91 94262 84715', '915752790', '9909005694', '+91 79 2589 4542 / +91 9429207992', '+9179 2657 8369', '+91793013 0200', '07926306752', '+91 98981 37147', '+91 99-98-264810', '+91 79 2656 5222', '+919879566257', '07965422223', '(+91-79) 4032-7226'}
    

- The observations that can be drawn from the above list phone numbers are:
  1. Some of the phone numbers are starting with coutry code **"+91" or 91** like **+91 79 2550 7181, "917926314000" .**
  2. some of the phone numbers are starting with **Zero** like **"079 6619 0201".**
  3. Some numbers are having Parentheses in them like **"(+91-79) 4032-7226".** 
  4. Some numbers are standered **ten digit** phone numbers like **"7926620059".**
  5. Some places have multiple phone numbers like **"+91 79 6190 0500/05/06/07/08/09".**
  6. Some numbers are having incorrect format like **"915752790".**
  
- Now lets write a function to convert all the phone numbers to **standard format** like **"+91 88 7777 6666"**  


```python
def rectify_phone_number(phone_number):
    '''This function is written to rectify a given phone number'''
    detect_multiple = re.compile(r'[/;]')
    match = re.search(detect_multiple,phone_number)
    num_lst = []
    rectified_lst = []
    if len(phone_number) < 10:
        return "Invalid Phone Number"
    else:
        if match:
            num_lst = convert_to_lst(phone_number,match.group())
        else:   
            num_lst = [phone_number]
        
        rectified_lst = validate_and_remove_problem_chars(num_lst)
        
        if len(rectified_lst) == 1:
            return rectified_lst[0]
        else:
            return rectified_lst

```


```python
def convert_to_lst(phone_number,split_val):
    '''This function is written to handle 
    multiple phone numbers scenario'''
    num_lst = phone_number.split(split_val)
    nw_lst = []
    nw_lst.append(num_lst[0])
    for i in range(1,len(num_lst)):
        if len(num_lst[i]) < 10:
            new_num = num_lst[0][:len(num_lst[0])-len(num_lst[i])] + num_lst[i]
            nw_lst.append(new_num)
        else:
            nw_lst.append(num_lst[i])
    
    return nw_lst
```


```python
def validate_and_remove_problem_chars(num_lst):
    '''This function is written to validate a 
    given phone number aganist standard format'''
    correct_format = re.compile(r'^(\+91) \d{2} \d{4} \d{4}')
    new_lst = []
    for number in num_lst:
        match = re.search(correct_format,number)
        if match :
            new_lst.append(number)
        else : 
            new_number = change_to_standard_format(number)
            new_lst.append(new_number)
    
    return new_lst 
```


```python
def change_to_standard_format(phone_number):
    '''This function is written to convert a given phone number to standard format'''
    new_number = phone_number.replace('(','').replace(')','').replace('-','').replace(' ','')
    if new_number.startswith('+91'):
        new_number = '+91 ' + new_number[3:5] + ' ' + new_number[5:9] + ' ' +new_number[9:14]
    elif new_number.startswith('91'):
        new_number = '+91 ' + new_number[2:4] + ' ' + new_number[4:8] + ' ' +new_number[8:13]
    elif new_number.startswith('0'):
        new_number = '+91 ' + new_number[1:3] + ' ' + new_number[3:7] + ' ' +new_number[7:12]
    else:
        new_number = '+91 ' + new_number[:2] + ' ' + new_number[2:6] + ' ' +new_number[6:11]
    return new_number          
```

- As output is large, I am writing it to an external file **"correct_ph_numbers.txt".** 


```python
output_data(phone_numbers,rectify_phone_number,"correct_ph_numbers.txt")    
```

## Problems Encountered In Street Names

- Now lets audit what are the different street names present in the dataset.


```python
street_names = process_tags(INPUT_FILENAME,"addr:street")
output_data(street_names,filename="street_names.txt")    
```

- The observations that can be drawn from street data are :
  1. Most of the street names are either ending with word **road or marg** which are in correct format.
  2. Few street names are in incorrect format i.e, they are having city, country name in them for eg.**"Uttamnagar, Ahmedabad".**
  3. One of the Street names is mentioned in local language **"Hindi"** like **"एरपोर्ट रोड"**.
  4. Some of the street names are in lower case letters, some of them are in upper case.
  
- Now lets write a function that would process a given street name and convert it into a standard format.
- Lets create a dictionary that would contain incorrect names as keys and correct names as values, if a given street name is  found in that dictionary, we will return the correct value , else will return the given street name in standard format.


```python
def rectify_street_name(street_name):
    incorrect_names = {'एरपोर्ट रोड': 'Airport Road'}
    if street_name in incorrect_names:
        return incorrect_names[street_name]
    else:
        new_street_name = street_name.lower().strip(' ')        
        if new_street_name.endswith('ahmedabad'):
            new_street_name = new_street_name.replace('ahmedabad','').replace(',','')
        elif new_street_name.endswith('gujarat, india'):
            new_street_name = new_street_name.replace('gujarat, india','').replace(',','')  
        return new_street_name.title()
```

- As output will be large, I am writing it to an external file **"correct_street_names.txt".**


```python
output_data(street_names,rectify_street_name,"correct_street_names.txt")  
```

## Problems Encountered In Cuisine Data

- Now lets audit data present in **"cuisine"** tag.


```python
cuisines = process_tags(INPUT_FILENAME,"cuisine")
(cuisines)
```




    {'Coffee and Snacks',
     'Gujarati',
     'Punjabi,_SouthIndia,_Gujarati Thali.',
     'burger',
     'burger;sandwich;regional;ice_cream;grill;cake;coffee_shop;pasta;noodles;pancake;pizza;chicken;fish_and_chips;curry;indian;vegan;fish;breakfast;savory_pancakes;tea;seafood;sausage;local;barbecue;vegetarian',
     'ice_cream',
     'indian',
     'international',
     'italian',
     'multicuisine',
     'pizza',
     'regional',
     'sandwich',
     'sandwich;regional;cake;coffee_shop;asian;pasta;noodles;pancake;pizza;indian;mexican;sausage;tea;italian;barbecue;vegetarian',
     'vegetarian'}



- The observations that can be drawn from the cuisine data are:
    1. Few of the tags contain a single value.
    2. Few of the tags contain more than one value .
    
    
- Lets write a function that does the following:
    1. If cuisine tag has a single value, it will return that value.
    2. If cuisine tag has more than one value,it will return list of those values.


```python
def rectify_cuisine_data(cuisine):
    cuisine_pattern = re.compile(r'[,;]')
    match = re.search(cuisine_pattern,cuisine)
    
    if match:
        cuisine_lst = cuisine.split(match.group())
        return [cuisine.title() for cuisine in cuisine_lst]
    
    else:
        return [cuisine.title()]
    
output_data(cuisines,func=rectify_cuisine_data)    
```

    sandwich ----> ['Sandwich']
    sandwich;regional;cake;coffee_shop;asian;pasta;noodles;pancake;pizza;indian;mexican;sausage;tea;italian;barbecue;vegetarian ----> ['Sandwich', 'Regional', 'Cake', 'Coffee_Shop', 'Asian', 'Pasta', 'Noodles', 'Pancake', 'Pizza', 'Indian', 'Mexican', 'Sausage', 'Tea', 'Italian', 'Barbecue', 'Vegetarian']
    international ----> ['International']
    pizza ----> ['Pizza']
    Coffee and Snacks ----> ['Coffee And Snacks']
    multicuisine ----> ['Multicuisine']
    regional ----> ['Regional']
    vegetarian ----> ['Vegetarian']
    burger;sandwich;regional;ice_cream;grill;cake;coffee_shop;pasta;noodles;pancake;pizza;chicken;fish_and_chips;curry;indian;vegan;fish;breakfast;savory_pancakes;tea;seafood;sausage;local;barbecue;vegetarian ----> ['Burger', 'Sandwich', 'Regional', 'Ice_Cream', 'Grill', 'Cake', 'Coffee_Shop', 'Pasta', 'Noodles', 'Pancake', 'Pizza', 'Chicken', 'Fish_And_Chips', 'Curry', 'Indian', 'Vegan', 'Fish', 'Breakfast', 'Savory_Pancakes', 'Tea', 'Seafood', 'Sausage', 'Local', 'Barbecue', 'Vegetarian']
    italian ----> ['Italian']
    Punjabi,_SouthIndia,_Gujarati Thali. ----> ['Punjabi', '_Southindia', '_Gujarati Thali.']
    indian ----> ['Indian']
    Gujarati ----> ['Gujarati']
    ice_cream ----> ['Ice_Cream']
    burger ----> ['Burger']
    

- Now lets write a function that will convert the xml dataset to json documents, which can be later be inserted to mongoDB.


```python
CREATED = [ "version", "changeset", "timestamp", "user", "uid"]
EXPECTED = ["amenity","cuisine","name","phone","religion","atm",'building','landuse',
            'highway','surface','lanes','bridge','maxspeed','leisure','sport']

speed = re.compile(r'(\d)*')

def create_element(element):
    '''This function is written to convert each xml tag to a json document'''
    
    node = {}
    if element.tag == "node" or element.tag == "way" :
        # YOUR CODE HERE
        created_dict = {}
        attributes = element.attrib
        pos = []
        for k,v in attributes.items():
            if k in CREATED :
                created_dict[k] = v
            else:
                if k not in ["lat","lon"]:
                    node[k] = v
        node["type"] = element.tag
        
        if "lat" in attributes and "lon" in attributes:
            node["pos"] = [float(attributes["lat"]),float(attributes["lon"])]     
        node["created"] = created_dict 
        
        node_refs = []
        address = {}
        
        for elem in element.iter('nd'):
            node_refs.append(elem.attrib["ref"])
            
        for elem in element.iter('tag'):
            tag_k = elem.attrib['k']
            tag_v = elem.attrib['v']

            
            if tag_k == "postal_code":
                tag_k = "addr:postcode"
                                            
            if tag_k.startswith('addr:') and  tag_k.count(':') == 1:
                
                if tag_k == "addr:postcode" and tag_v not in correct_postal_code_set:
                    tag_v = None
                
                elif tag_k == "addr:city" :
                    tag_v = rectify_city_name(tag_v)
                 
                elif tag_k == "addr:street":
                    tag_v = rectify_street_name(tag_v)
                
                
                if tag_v != None:
                    address[tag_k.split(':')[1]] = tag_v
                
            elif tag_k in EXPECTED:
                
                if tag_k == "phone":
                    tag_v = rectify_phone_number(tag_v)
                    if tag_v == "Invalid Phone Number":
                        tag_v = None
                        
                elif tag_k == "cuisine":
                    tag_v = rectify_cuisine_data(tag_v)
                    
                elif tag_k == "maxspeed" or tag_k == 'lanes':
                    match = re.search(speed,tag_v)
                    tag_v = int(match.group())
                
                if tag_v != None:            
                    node[tag_k] = tag_v
                                
        if len(node_refs) !=0 :
            node["node_refs"] = node_refs
            
        if len(address) != 0:
            node["address"] = address
    
        
        return node
    else:
        return None
```


```python
def process_map(file_in, pretty = False):
    '''This function is written to create json files'''
    file_out = "{0}.json".format(file_in)
    with codecs.open(file_out, "w") as fo:
        for _, element in ET.iterparse(file_in):
            el = create_element(element)
            if el:
                if pretty:
                    fo.write(json.dumps(el, indent=2)+"\n")
                else:
                    fo.write(json.dumps(el) + "\n")
```


```python
process_map(INPUT_FILENAME)
```

## Data Wrangling With DB and File Sizes



```python
client = pymongo.MongoClient('localhost:27017')
db_name = 'openstreetmap'
collection_name = 'ahmedabadData'
file_name = 'ahmedabad_india1.osm.json'

db = client[db_name]
ahmedabad_osm = db[collection_name]
    
if collection_name in db.collection_names():
    ahmedabad_osm.drop()

cmd = "mongoimport --db " + db_name +' --collection ' + collection_name + ' --file ' +   file_name
subprocess.call(cmd)
```




    0




### File sizes


```python
def getSize(filename):
    input_file_size_b = os.path.getsize(filename)
    input_file_siz_mb = (input_file_size_b)/(1024*1024)
    return round(input_file_siz_mb,2)

print("Size of the input file: {0} MB".format(getSize(INPUT_FILENAME)))
print("Size of the ouput Json file: {0} MB".format(getSize("ahmedabad_india1.osm.json")))
```

    Size of the input file: 108.54 MB
    Size of the ouput Json file: 128.03 MB
    

###  Number of records


```python
total_records = ahmedabad_osm.find().count()
print('Total Number Of Records: ',total_records)
```

    Total Number Of Records:  627356
    

###  Number of nodes


```python
total_nodes = ahmedabad_osm.find({"type":"node"}).count()
print('Number of nodes: ',total_nodes)
```

    Number of nodes:  546085
    

### Number of ways :


```python
total_nodes = ahmedabad_osm.find({"type":"way"}).count()
print('Number of ways: ',total_nodes)
```

    Number of ways:  81271
    

###  Number of unique users


```python
distinct_users = len(ahmedabad_osm.distinct('created.user'))
print('Number of users contributed: ',distinct_users)
```

    Number of users contributed:  349
    

### Top 3 users who contributed


```python
top_three_users = ahmedabad_osm.aggregate([{"$group":{"_id":"$created.user",
                                   "count":{"$sum":1}}},
                        {"$sort":{"count":-1}},
                        {"$limit":3}])

for user in top_three_users:
    print("Total number of entries {0} made : {1}".format(user["_id"],user["count"]))
```

    Total number of entries uday01 made : 177332
    Total number of entries sramesh made : 136709
    Total number of entries chaitanya110 made : 123138
    

## Further Data Exploration With MongoDB

### Top 10 Amenities


```python
top_five_amenities = ahmedabad_osm.aggregate([{"$match":{"amenity":{"$exists":1}}},
                                             {"$group":{"_id":"$amenity",
                                                       "count":{"$sum":1}}},
                                             {"$sort":{"count":-1}},
                                             {"$limit":10}])

for amenity in top_five_amenities:
    print("Total number of {0}'s Present : {1}".format(amenity["_id"].title(),amenity["count"]))
```

    Total number of Place_Of_Worship's Present : 92
    Total number of Restaurant's Present : 59
    Total number of Hospital's Present : 48
    Total number of School's Present : 43
    Total number of Bank's Present : 33
    Total number of Fuel's Present : 29
    Total number of College's Present : 28
    Total number of Police's Present : 28
    Total number of Atm's Present : 24
    Total number of Fast_Food's Present : 23
    

### Top 5 Cuisines


```python
top_five_cuisines = ahmedabad_osm.aggregate([{"$unwind":"$cuisine"},
                                             {"$group":{"_id":"$cuisine",
                                                       "count":{"$sum":1}}},
                                            {"$sort":{"count":-1}},
                                            {"$limit":5}])

[cuisine["_id"].title() for cuisine in top_five_cuisines]    
```




    ['Regional', 'Indian', 'Pizza', 'Vegetarian', 'Ice_Cream']



### Religions  


```python
[val.title() for val in ahmedabad_osm.distinct('religion')]
```




    ['Hindu', 'Jain', 'Christian', 'Muslim', 'Nonsectarian', 'Zoroastrian']



### Top 5 Building Types


```python
top_five_building_types = ahmedabad_osm.aggregate([{"$match":{"building":{"$exists":1,"$ne":"yes"}}},
                                                   {"$group":{"_id":"$building",
                                                       "count":{"$sum":1}}},
                                                    {"$sort":{"count":-1}},
                                                    {"$limit":5}])
for building_type in top_five_building_types:
    print("{0}: {1}".format(building_type["_id"].title(),building_type["count"]))
```

    Commercial: 138
    Apartments: 105
    House: 104
    Residential: 88
    University: 29
    

### Top 3 Landuses


```python
top_three_landuses = ahmedabad_osm.aggregate([{"$match":{"landuse":{"$exists":1}}},
                                               {"$group":{"_id":"$landuse","count":{"$sum":1}}},
                                               {"$sort":{"count":-1}},
                                               {"$limit":3}])

for landuse in top_three_landuses:
    print("{0}: {1}".format(landuse["_id"].title(),landuse["count"]))
```

    Residential: 319
    Commercial: 89
    Industrial: 53
    

### Leisure Types


```python
print(ahmedabad_osm.distinct('leisure'))
```

    ['sports_centre', 'park', 'garden', 'swimming_pool', 'pitch', 'stadium', 'playground', 'recreation_ground', 'track', 'golf_course']
    

### Sport Types


```python
print(ahmedabad_osm.distinct('sport'))
```

    ['multi', 'swimming', 'basketball', 'volleyball', 'cricket', 'tennis', 'skating', 'cricket,_football', 'running', 'soccer']
    

### Way Tag Data Exploration
#### 1. Highway Types


```python
highway_types = ahmedabad_osm.distinct('highway')
print(highway_types)
```

    ['crossing', 'traffic_signals', 'bus_stop', 'turning_circle', 'residential', 'street_lamp', 'rest_area', 'unclassified', 'primary', 'motorway', 'tertiary', 'pedestrian', 'trunk', 'footway', 'secondary', 'service', 'primary_link', 'living_street', 'motorway_link', 'trunk_link', 'tertiary_link', 'path', 'cycleway', 'secondary_link', 'track', 'road', 'steps', 'construction', 'bridleway']
    

#### 2. Surface Types


```python
surface_types = ahmedabad_osm.aggregate([{"$match":{"surface":{"$exists":1}}},
                        {"$group":{"_id":"$surface","count":{"$sum":1}}},
                         {"$sort":{"count":-1}}])

for type in surface_types:
    print("{0}: {1}".format(type["_id"].title(),type["count"]))
```

    Asphalt: 117
    Paved: 81
    Unpaved: 9
    Concrete: 6
    Gravel: 3
    Paving_Stones: 3
    Concrete:Plates: 3
    Ground: 2
    Grass: 2
    Sand: 1
    Metalroad: 1
    Dirt: 1
    

#### 3. Bridges


```python
bridges = ahmedabad_osm.aggregate([{"$match":{"bridge":"yes"}},
                        {"$group":{"_id":"$name"}}])

print(sorted([bridge["_id"].title() for bridge in bridges if bridge["_id"] != None]))
```

    ['132 Ft. Ring Road', 'Ahmadabad Vadodara Expressway', 'Anupam Bridge | Kankaria Railway Overbridge', 'Broken Bridge', 'Brts Route', 'Chamunda Flyover', 'Chandlodia Bridge', 'Chimanbhai Patel  Bridge', 'Ellisbridge', 'Fernandiz Bridge', 'Gandhi Bridge', 'Gandhinagar-Ahmedabad Highway', 'Gota Road', 'Gulbai Tekra Road', 'Iim Overbridge', 'Indira Bridge', 'Isckon Overbridge', 'Jamalpur Flyover Bridge', 'Kavi Nanalal Marg', 'Naroda Road', 'Nathalal Jhagadia Bridge', 'Nehru Bridge', 'Nh8A', 'Pirana Chandranagar Bridge', 'Proposed  Railway Overbridge', 'Proposed Railway Overbridge', 'Railway Foot Over Bridge', 'Rakhial Odhav Road', 'Rakhial Road', 'Rana Pratap Marg', 'Rishi Dadhichi Bridge', 'Sabarmati Riverfront Road', 'Sardar Bridge', 'Sardar Patel Ring Road', 'Small Bridge', 'Sola Road', 'Subhash Bridge', 'Western Railway Line']
    

#### 4.  Top 2 MaxSpeeds


```python
max_speeds = ahmedabad_osm.aggregate([{"$match":{"maxspeed":{"$exists":1}}},
                                      {"$group":{"_id":"$name","speed":{"$max":"$maxspeed"}}},
                                      {"$sort":{"speed":-1}},
                                      {"$limit":2}])
for speed in max_speeds:
    print("{0}: {1} Mph".format(speed["_id"].title(),speed["speed"]))
```

    Gulbai Tekra Road: 120 Mph
    Ahmadabad Vadodara Expressway: 100 Mph
    

#### 5. Roads With Max Lanes


```python
max_lanes = ahmedabad_osm.aggregate([{"$match":{"lanes":{"$exists":1}}},
                                      {"$group":{"_id":"$name","speed":{"$max":"$lanes"}}},
                                      {"$sort":{"speed":-1}},
                                      {"$limit":2}])
for lane in max_lanes:
    print("{0}: {1} Lanes".format(lane["_id"].title(),lane["speed"]))
```

    Nh8: 4 Lanes
    Vatwa Road: 4 Lanes
    

### Geospatial Indexing

- The below function will return the nearby matches for a given amenity and position co-ordinates.


```python
def return_nearby_amenities(nearby_amenity,pos_list,nearby_limit):
    ahmedabad_osm.create_index([('pos',pymongo.GEO2D),('amenity',1)])
    nearby_data = ahmedabad_osm.find({"pos":{"$near":pos_list},"amenity":nearby_amenity}).limit(nearby_limit)
    
    for val in nearby_data:
        print(val)
```

#### 1. Near By Banks


```python
return_nearby_amenities('bank',[23.0945918,72.6119846],3)   
```

    {'_id': ObjectId('59314f949e4327d8804d3660'), 'id': '3500459657', 'type': 'node', 'pos': [23.0835179, 72.5909029], 'created': {'version': '1', 'timestamp': '2015-05-06T06:50:43Z', 'changeset': '30832181', 'uid': '2893945', 'user': 'Nikita Agarwal'}, 'atm': 'yes', 'name': 'HDFC Bank', 'amenity': 'bank'}
    {'_id': ObjectId('59314f949e4327d8804d3668'), 'id': '3500459666', 'type': 'node', 'pos': [23.0825491, 72.5900739], 'created': {'version': '1', 'timestamp': '2015-05-06T06:50:44Z', 'changeset': '30832181', 'uid': '2893945', 'user': 'Nikita Agarwal'}, 'atm': 'yes', 'name': 'Bank of Baroda', 'amenity': 'bank'}
    {'_id': ObjectId('59314f949e4327d8804d3663'), 'id': '3500459659', 'type': 'node', 'pos': [23.0834501, 72.5888148], 'created': {'version': '1', 'timestamp': '2015-05-06T06:50:44Z', 'changeset': '30832181', 'uid': '2893945', 'user': 'Nikita Agarwal'}, 'name': 'Gol Bank', 'amenity': 'bank'}
    

#### 2. Near By Hospitals


```python
return_nearby_amenities('hospital',[23.0945918,72.6119846],3)
```

    {'_id': ObjectId('59314f939e4327d8804c78a1'), 'id': '611572691', 'type': 'node', 'pos': [23.0924908, 72.5917525], 'created': {'version': '1', 'timestamp': '2010-01-11T08:02:54Z', 'changeset': '3594021', 'uid': '217810', 'user': 'Shardendu'}, 'amenity': 'hospital'}
    {'_id': ObjectId('59314f949e4327d8804d365b'), 'id': '3500459652', 'type': 'node', 'pos': [23.0829627, 72.5906964], 'created': {'version': '1', 'timestamp': '2015-05-06T06:50:43Z', 'changeset': '30832181', 'uid': '2893945', 'user': 'Nikita Agarwal'}, 'name': 'Pukhraj Hospital', 'amenity': 'hospital', 'address': {'city': 'Ahmedabad', 'postcode': '380005'}}
    {'_id': ObjectId('59314f949e4327d8804d3657'), 'id': '3500454471', 'type': 'node', 'pos': [23.0836049, 72.5901213], 'created': {'version': '1', 'timestamp': '2015-05-06T06:40:57Z', 'changeset': '30831958', 'uid': '2893945', 'user': 'Nikita Agarwal'}, 'name': 'Geeta Maternity Hospital', 'amenity': 'hospital', 'address': {'city': 'Ahmedabad', 'postcode': '380005'}}
    

#### 3. Near By Restaurants


```python
return_nearby_amenities('restaurant',[23.0945918,72.6119846],3)
```

    {'_id': ObjectId('59314fa19e4327d880547060'), 'id': '4481532989', 'type': 'node', 'pos': [23.111054, 72.6050699], 'created': {'version': '1', 'timestamp': '2016-11-04T11:14:31Z', 'changeset': '43398935', 'uid': '4112063', 'user': 'kailashdhirwani'}, 'name': 'AFC Garden Restaurant', 'amenity': 'restaurant'}
    {'_id': ObjectId('59314f939e4327d8804c789c'), 'id': '611572686', 'type': 'node', 'pos': [23.1057395, 72.5975686], 'created': {'version': '1', 'timestamp': '2010-01-11T08:02:53Z', 'changeset': '3594021', 'uid': '217810', 'user': 'Shardendu'}, 'amenity': 'restaurant'}
    {'_id': ObjectId('59314fa29e4327d880549420'), 'id': '4672030298', 'type': 'node', 'pos': [23.0687153, 72.5807241], 'created': {'version': '1', 'timestamp': '2017-02-07T14:13:46Z', 'changeset': '45886810', 'uid': '5276500', 'user': 'Silene Hoiry'}, 'amenity': 'restaurant'}
    

#### 4. Near By Cinema


```python
return_nearby_amenities('cinema',[23.0945918,72.6119846],3)
```

    {'_id': ObjectId('59314f939e4327d8804c78a0'), 'id': '611572690', 'type': 'node', 'pos': [23.0923921, 72.5938017], 'created': {'version': '1', 'timestamp': '2010-01-11T08:02:54Z', 'changeset': '3594021', 'uid': '217810', 'user': 'Shardendu'}, 'amenity': 'cinema'}
    {'_id': ObjectId('59314fa29e4327d88054787e'), 'id': '4488103325', 'type': 'node', 'pos': [23.0810593, 72.6415185], 'created': {'version': '1', 'timestamp': '2016-11-08T06:52:17Z', 'changeset': '43480049', 'uid': '4112063', 'user': 'kailashdhirwani'}, 'name': 'Maya CINEMA -CLOSED', 'amenity': 'cinema'}
    {'_id': ObjectId('59314f949e4327d8804cebd3'), 'id': '2699807313', 'type': 'node', 'pos': [23.0664215, 72.5316963], 'created': {'version': '1', 'timestamp': '2014-03-03T12:25:12Z', 'changeset': '20887124', 'uid': '1964435', 'user': 'trishul'}, 'name': 'Rajhans Multiplex', 'amenity': 'cinema'}
    
