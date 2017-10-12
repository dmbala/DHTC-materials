import os
import re

files = [f for f in os.listdir('.') if re.match(r'prob_wigner[0-9]*.dat', f)]
ave_value = dict()
for datfile in files:
    fhand = open(datfile)
    for line in fhand:
        words = line.split()
        key = float(words[0])
        value = float(words[1])
        if key in ave_value:
            ave_value[key] += value
        else:
            ave_value[key] = value

key_value_list = []
[key_value_list.append((k,v)) for k, v in ave_value.items()]

key_value_list.sort(key=lambda x: float(x[0]))
n = len(key_value_list)
for i in range(0, n):
    words = key_value_list[i]
    print '{0:9.4f} {1:9.4f}'.format(words[0],  float(words[1])/len(files))
   

