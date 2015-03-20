 #!/usr/bin/python
 # -*- coding: utf-8 -*-

from bs4 import BeautifulSoup
import cPickle as pickle

"""
Parses each job listing in page as a Job object
"""
class JobListings(object):

	label_to_attr = {'Position Type:':'jobtype', 'Location:':'location', 'Description:':'desc', 'Job Function:':'func', 'Job Location(s):':'location', \
					'Job Duration:':'duration', 'Approximate Hours Per Week:':'hoursperwk', 'Salary Level:':'salary', 'Qualification:':'qualifications', \
					'Qualifications:':'qualifications', 'Salary Range:':'salary', 'Hours Per Week:':'hoursperwk'}

	unknowns = set()

	def __init__(self, text):
		self.soup = BeautifulSoup(text)
		self.length = 0
		self.listings = []
		self.parse_all()

	def parse_all(self):
		job = self.soup.body.find("div", class_="job", recursive=False)
		while job:
			self.parse_job(job)
			job = job.find_next_sibling("div", class_="job")

	def parse_job(self, job):
		title = job.h3.string.encode('utf-8').strip()
		company = job.h4.get_text().encode('utf-8').strip()
		newjob = Job(title, company)
		for tr in job.find_all('tr'):			
			label = tr.td.string.encode('utf-8').strip()
			data = tr.td.find_next_sibling("td").get_text().encode('utf-8').strip()
			# print label, data
			if label not in JobListings.label_to_attr:
				JobListings.unknowns.add(label)
				continue
			setattr(newjob, JobListings.label_to_attr[label], data)
		self.listings.append(newjob)
		self.length += 1
		# print 'Listing %d: ' % self.length, newjob

	def get(self, jobid):
		self.listings[jobid].view()

	def __str__(self):
		s = ''
		for i,job in enumerate(self.listings):
			s += 'Listing %d: ' % (i+1) + job.__str__() + '\n'
		return s


class Job(object):

	def __init__(self, title, company): # jobtype='', location='', desc='', func='', duration='', hoursperwk='', salary='', qualifications=''
		self.title = title
		self.company = company
		# self.type = jobtype
		# self.location = location
		# self.description = desc
		# self.function = func
		# self.duration = duration
		# self.hoursperwk = hoursperwk
		# self.salary = salary
		# self.qualifications = qualifications

	def view(self):
		for n,a in JobListings.label_to_attr.items():
			if getattr(self, a, False):
				print n, getattr(self, a)

	def __str__(self):
		return self.title + ', ' + self.company

def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)

with open("121914-cs.html") as f:
	l = JobListings(f.read())
	save_object(l.listings, r'joblistings-cs.pkl')
	# l = JobListings(TEXT)
	# print JobListings.unknowns
	# print l
	# l.get(0)
	# print '\n'
	# l.get(1234)
