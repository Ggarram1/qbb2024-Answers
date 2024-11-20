#python dictionary: built in data structure to hold multiple pieces of information
#   denoted by curly brackets {}
my_dict = { "a":1, 5:"blue", True:[0,1,2]}

#adding and replacing value-key pairs in dictionaries:
my_dict["some key"] = "my value"
#this may adda this new pair to the dictionary OR overwrite the previous value for the key "some key"

#to look for keywords:
my_dict = {1:"a", 2:"b", 3:"c", 5:"e"}
presence = 1 in my_dict
print(presence)
#this will print either true or false AND can be added to an "if" statement

#this will show us the first time each word appears in the phrase
>>> S = "it was the best of times it was the worst of times"
>>> S=S.split(' ')
>>> S
#this is showing the phrase as individual indexes
['it', 'was', 'the', 'best', 'of', 'times', 'it', 'was', 'the', 'worst', 'of', 'times']
#this is creating a new and empty dictionary
>>> first = {}
#this is saying that for each index in the above list, a variable is assigned ("word")
#this will be update for each index
#if the word is already in the new dictionary, the program will continue
#otherwise, the index will be assigned to the first occurance 
>>> for i in range(len(S)):
...     word = S[i]
...     if word in first:
...             continue
...     else:
...             first[word] = i
... 
>>> first
{'it': 0, 'was': 1, 'the': 2, 'best': 3, 'of': 4, 'times': 5, 'worst': 9}

 >>> S = "it was the best of times it was the worst of times"
>>> S=S.split
>>> counts = dict()
>>> for i in range(len(S)):
...     char = S[i]
...     if char not in counts:
...             counts[char] = 0
...     counts[char] +=1
...     print(char, counts[char])

my_dict = {"a":1, "b":2}
result = my_dict.get("c")
print(result)

my_dict = {"a":1, "b":2}
my_dict.setdefault("c",3)
print(my_dict[c])

my_dict = {"a":1, "b":2}
del_my_dict["a"]
print(my_dict)
{2,"b"}

my_dict = {"a":1, "b":2}
value = my_dict.pop("a")
print(value, my_dict)
1{2:"b"}

Patients = {"john smith":"P0345", "jane doe":"P6634"}
#getting only keys:
for name in patients.keys():
    print(name)

#getting only values:
for ID in patients.values():
    print(ID)

#getting both:
for pair in patients.items():
    print(pair)
#OR
for name, ID in patients.items():
    print(name, ID)


Practice Excercise:
>>> metadata = [["S001", "P001", "heart"]]
>>> metadict={}
>>> for i in range(len(metadata)):
...     sample, patient, tissue = metadata[i]
...     key = (patient, tissue)
...     metadict.setdefault(key,[])
...     metadict[key].append(sample)
... 
[]
>>> metadict
{('P001', 'heart'): ['S001']}