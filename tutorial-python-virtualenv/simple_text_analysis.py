
import nltk, os
from nltk import sent_tokenize, word_tokenize, pos_tag

curr_dir = os.getcwd()+str("/nltk_data")
nltk.data.path.append(curr_dir)

text="It was a bright cold day in April, and the clocks were striking thirteen."

tokens = word_tokenize(text)
#tagged_tokens = pos_tag(tokens)
tagged_tokens = pos_tag(tokens, tagset='universal')

for values in tagged_tokens:
    print("WORD= %-30s,     TAG= %s" %(values[0], values[1]))


