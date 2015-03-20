
# coding: utf-8
"""
From jobtagger.ipynb, assigns each job listing with a set of tags and saves all data into .pkl file for uploading.
"""

# In[2]:

import cPickle as pickle
from htmlparser import JobListings, Job
import numpy as np
import re
import scipy.sparse
import string
from sklearn import linear_model
from sparsesvd import sparsesvd
import sys
sys.path.append('tagger/')
import tagger
import stemming
import build_dict

listings = []
with open('joblistings.pkl', 'rb') as f:
    listings = pickle.load(f)    


# In[3]:



weights = pickle.load(open('tagger/data/dict.pkl', 'rb')) # or your own dictionary
# myreader = tagger.Reader() # or your own reader class
# mystemmer = tagger.Stemmer() # or your own stemmer class
# myrater = tagger.Rater(weights) # or your own... (you got the idea)
# mytagger = Tagger(myreader, mystemmer, myrater)
# best_3_tags = mytagger(text_string, 3)



# In[48]:

stop = ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your', 'yours',
        'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her', 'hers', 'herself',
        'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which',
        'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be',
        'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an',
        'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by',
        'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before',
        'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over',
        'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why',
        'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no',
        'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will',
        'just', 'don', 'should', 'now', 'skills']

weights = pickle.load(open('jobtagdict.pkl', 'rb')) # or your own dictionary
# weights2 = pickle.load(open('skilltagdict.pkl', 'rb'))
weights2 = pickle.load(open('tagger/data/dict.pkl', 'rb'))
myreader = tagger.Reader() # or your own reader class
mystemmer = tagger.Stemmer() # or your own stemmer class
myrater = tagger.Rater(weights) # or your own... (you got the idea)
myrater2 = tagger.Rater(weights2)
jobtagger = tagger.Tagger(myreader, mystemmer, myrater)
skilltagger = tagger.Tagger(myreader, mystemmer, myrater2)


# In[ ]:

with open("stopwords.pkl") as f:
    l = JobListings(f.read())
    save_object(l.listings, r'joblistings-cs.pkl')


# In[46]:

with open('jobtagcorpus.txt', 'wb') as f:
    for job in listings:
        f.write(job.desc)
        if getattr(job, 'qualifications', False):
            f.write(job.qualifications)


# In[29]:

with open('skilltagcorpus.txt', 'wb') as f:
    for job in listings:
        if getattr(job, 'qualifications', False):
            f.write(job.qualifications)


# In[31]:

build_dict.build_dict_from_files('skilltagdict.pkl', ['skilltagcorpus.txt'], stopwords_file='stopwords.txt', measure='ICF')


# In[47]:

build_dict.build_dict_from_files('jobtagdict.pkl', ['jobtagcorpus.txt'], stopwords_file='stopwords.txt', measure='ICF')


# In[53]:

text_string = listings[5].qualifications
jobtagger(text_string, 3)


# In[89]:

j = listings[1]
text_string = j.desc + '\n' + j.qualifications
q = jobtagger(text_string, 5)
[repr(x)[1:-1] for x in q]


# In[90]:

len(listings)


# In[91]:

import cPickle as pickle

### mutate jobs
for job in listings:
    text_string = job.desc
    tags = [repr(x)[1:-1] for x in jobtagger(text_string, 5)]
    setattr(job, 'tags', tags)
    if getattr(job, 'qualifications', False):
        text_string = job.qualifications
        skills = [repr(x)[1:-1] for x in jobtagger(text_string, 3)]
        setattr(job, 'skills', skills)
    else:
        setattr(job, 'qualifications', '')
        setattr(job, 'skills', '')
        
def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)
        
with open(r'joblistings-tagged.pkl', 'wb') as f:    
    pickle.dump(listings, f, pickle.HIGHEST_PROTOCOL)
   


# In[93]:

with open(r'joblistings-tagged.pkl', 'wb') as f:    
    pickle.dump(listings, f, pickle.HIGHEST_PROTOCOL)

