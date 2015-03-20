import sys
sys.path.append('tagger/')
import unittest
import os
import cPickle as pickle
from htmlparser import JobListings, Job
import traceback
import httplib
import json

"""
PostJobs updates web application database with new job listings using REST API
"""
class PostJobs():
    server = "localhost:3000"

    def __init__(self, listings):
        self.listings = listings
        for i,job in enumerate(listings):
            self.make(job)
            print i


    def makeRequest(self, url, method="POST", data={ }):
        printHeaders = (os.getenv("PRINT_HEADERS", False) != False)
        headers = { }
        body = ""  
        if data is not None:
            headers = { "content-type": "application/json",  "accept": "application/json" }
            body = json.dumps(data)

        try:
            self.conn.request(method, url, body, headers)
        except Exception, e:
            if str(e).find("Connection refused") >= 0:
                print "Cannot connect to the server "+PostJobs.server+"."
                sys.exit(1)
            raise

        self.conn.sock.settimeout(500.0) # Give time to the remote server to start and respond

    def make(self, job):
        self.setUp()
        self.make_company(job)
        self.tearDown()
        self.setUp()
        self.make_job(job)
        self.tearDown

    def make_company(self, job):
        cdata = { 'hack': 1296, 'company_name': job.company, 'company_info':''}
        self.makeRequest("/company/add", method="POST", data=cdata)
        
    def make_job(self, job):
        info = job.desc 
        if job.qualifications:
            info += '\n' + 'QUALIFICATIONS:' + '\n' + job.qualifications
        jdata = { 'hack': 1296, 'title': job.title, 'company_name': job.company, 'job_type':job.jobtype, 'info':info, 'skills':job.skills, 'tags':job.tags }
        self.makeRequest("/posting/add", method="POST", data=jdata)

    def setUp(self):
        self.conn = httplib.HTTPConnection(PostJobs.server)
        
    def tearDown(self):
        self.conn.close ()


listings = []
with open('joblistings-tagged.pkl', 'rb') as f:
    listings = pickle.load(f)


PostJobs(listings)
