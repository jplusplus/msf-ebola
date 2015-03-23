#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import itertools, json
import utils_ebola
import sys
import datetime
import urllib
base_url = "https://docs.google.com/spreadsheets/d/1GcYq21TPdVAqIgNB3hAbS8xFkKExB7HtiB8CPHe6Ouw/export?"
urllib.urlretrieve(base_url + "gid=1687475652&format=csv", "Staff.csv")
urllib.urlretrieve(base_url + "gid=0&format=csv", "Admissions.csv")
urllib.urlretrieve(base_url + "gid=708066921&format=csv", "GIN.csv")
urllib.urlretrieve(base_url + "gid=1734489943&format=csv", "LBR.csv")
urllib.urlretrieve(base_url + "gid=1329473925&format=csv", "SLE.csv")
urllib.urlretrieve(base_url + "gid=487935842&format=csv", "Other.csv")

centers = [
	{
		"name":"Conakry - Guinea",
		"display_name": "Conakry",
		"position_file_1":8,
		"lat": 9.535601,
		"lng":-13.683686,
		"type": "CTE",
		"day_opened": 7,
		"day_closed":False
	},
	{
		"name":"Freetown - Sierra Leone",
		"display_name": "Freetown",
		"position_file_1":20,
		"lat": 8.484444, 
		"lng":-13.234444,
		"type": "CTE",
		"day_opened": 266,
		"day_closed": False
	},
	{
		"name":"Foya - Liberia",
		"display_name": "Foya",
		"position_file_1":12,
		"lat": 8.359997,
		"lng":-10.20675,
		"type": "CTE",
		"day_opened": 77,
		"day_closed":238
	},
	{
		"name":"Bo - Sierra Leone",
		"display_name": "Bo",
		"position_file_1":28,
		"lat": 7.955179,
		"lng":-11.740995,
		"type": "CTE",
		"day_opened": 182,
		"day_closed":308
	},
	{
		"name":"Kailahun - Sierra Leone",
		"display_name": "Kailahun",
		"position_file_1":24,
		"lat": 8.277222, 
		"lng":-10.573889,
		"type": "CTE",
		"day_opened": 98,
		"day_closed":308
	},
	{ 
		"name":"Gueckedou - Guinea",
		"display_name": "Guéckédou",
		"position_file_1":4,
		"lat": 8.5653717,
		"lng":-10.1295126,
		"type": "CTE",
		"day_opened": 0,
		"day_closed":False
	},{
		"name":"Monrovia - Liberia",
		"display_name": "Monrovia",
		"position_file_1":16,
		"lat": 6.239261,
		"lng":-10.696578,
		"type": "CTE",
		"day_opened": 147,
		"day_closed":False
	},
	{
		"name":"Grand Cape Mount",
		"display_name": "Grand Cape Mount",
		"position_file_1":False,
		"lat": 7.046776, 
		"lng":-11.071176,
		"type": "support",
		"day_opened": 0,
		"day_closed":False
	},
	{
		"name":"Faranah",
		"display_name": "Faranah",
		"position_file_1":False,
		"lat": 10.033333, 
		"lng":-10.733333,
		"type": "support",
		"day_opened": 0,
		"day_closed":False
	},
	{
		"name":"Kankan",
		"display_name": "Kankan",
		"position_file_1":False,
		"lat": 10.120923,  
		"lng":-9.545097,
		"type": "support",
		"day_opened": 0,
		"day_closed":False
	},
	{
		"name":"Kissidougou",
		"display_name": "Kissidougou",
		"position_file_1":False,
		"lat": 9.183333, 
		"lng":-10.1,
		"type": "support",
		"day_opened": 0,
		"day_closed":False
	},
	{
		"name":"Magburaka",
		"display_name": "Magburaka",
		"position_file_1":32,
		"lat": 8.7169, 
		"lng":-11.94,
		"type": "CTE",
		"day_opened": 268,
		"day_closed":False
	}
]

#Int'l staff at Magburaka
magburaka_staff = {
	"254":10,
	"261":17,
	"268":25,
	"275":22,
	"282":24,
	"289":29,
	"296":25,
	"303":31,
	"310":25,
	"317":25,
	"324":23,
	"331":23,
	"338":19,
	"345":16,
	"352":18
}

countries = ["SLE", "GIN", "LBR", "Other"]

last_day = 360

json_data = {}
recovered_msf_cumulative = 0
confirmed_msf_cumulative = 0
confirmed_msf_cumulative_w = 0
weekly_new_confirmed_prev = {}
staff_count_magburaka_prev = 0
step_number = 0

#Init weekly_new_confirmed_prev
i =0
while i < len(centers):
	center = centers[i]
	i += 1
	weekly_new_confirmed_prev[center["name"]] = 0

start_date = 1395446400 # Mar 22, 2014

file_1 = "Admissions.csv"

file_1_csv = open(file_1, "rb")
table_file_1 = csv.reader(file_1_csv)

file_2 = "Staff.csv"
file_2_csv = open(file_2, "rb")
table_file_2 = csv.reader(file_2_csv)


for day in range(0,last_day):
	sys.stdout.write("\nday\t"+str(day) + "\t")

	# increment the unix timestamp
	date = start_date + day * 86400

	day_obj = { "day": day, "centers":{}, "regional_data":{} }

	## Let's first compute a day by day summary of the admissions

	closest_lower_bound = utils_ebola.find_closest_date(day, file_1, 3, "lower")
	closest_upper_bound = utils_ebola.find_closest_date(day, file_1, 3, "upper")

	if (closest_upper_bound["numrow"] == -1):
			closest_upper_bound = closest_lower_bound

	# go through each center
	
	i = 0
	while i < len(centers):
		center = centers[i]
		i += 1

		weekly_new_confirmed = 0
		weekly_new_confirmed_smoothed = 0
		weekly_recovered = 0
		weekly_dead = 0

		if center["type"] == "CTE":
			file_1_csv.seek(0)
			lower_bound_row = next(itertools.islice(table_file_1, closest_lower_bound["numrow"], None))
			file_1_csv.seek(0)
			upper_bound_row = next(itertools.islice(table_file_1, closest_upper_bound["numrow"], None))

			if lower_bound_row[center["position_file_1"]] != "":
				weekly_new_confirmed = int(lower_bound_row[center["position_file_1"]])
			if lower_bound_row[center["position_file_1"] + 3] != "":
				weekly_recovered = int(lower_bound_row[center["position_file_1"] + 3])
			if lower_bound_row[center["position_file_1"] + 2] != "":
				weekly_dead = int(lower_bound_row[center["position_file_1"] + 2])

		#computes a smoothed version of the number of MSF confirmed cases
		
		step_number = datetime.datetime.fromtimestamp(date).weekday() + 1
		weekly_new_confirmed_smoothed = int(utils_ebola.evolution(weekly_new_confirmed_prev[center["name"]], weekly_new_confirmed, 7, step_number))

		if day % 7 == 0:
			recovered_msf_cumulative += weekly_recovered
			weekly_new_confirmed_prev[center["name"]] = weekly_new_confirmed
			confirmed_msf_cumulative += weekly_new_confirmed
			confirmed_msf_cumulative_w = confirmed_msf_cumulative_w + weekly_new_confirmed - weekly_dead - weekly_recovered
	
		#Is the center open on this day?
		is_open = False
		if day >= center["day_opened"] and (day < center["day_closed"] or center["day_closed"] == False):
			is_open = True
		else:
			# If the center ain't open, it shouldn't have patients yet. The problem is due to MSF's reporting weekly figures.
			weekly_new_confirmed = 0

		day_obj["centers"].update({center["name"]: {"is_open": is_open, "weekly_new_confirmed_smoothed":weekly_new_confirmed_smoothed, "weekly_new_confirmed": weekly_new_confirmed, "weekly_recovered": weekly_recovered}})

	day_obj["regional_data"].update({"recovered_msf_cumulative": recovered_msf_cumulative, "confirmed_msf_cumulative": confirmed_msf_cumulative, "confirmed_msf_cumulative_w": confirmed_msf_cumulative_w})
	
	## Now let's move on to the staff
	
	i = 0
	while i < len(centers):
		center = centers[i]
		i += 1

		staff_count = 0

		file_2_csv.seek(0)
		
		for row in table_file_2:
			# if employee is here on day
			if (row[3] != "start"):
				if (day >= int(row[3]) and day <= int(row[4]) and center["name"] == row[5]):
					staff_count+=1

		# Special Case Magburaka!
		if center["name"] == "Magburaka":

			if (str(day) in magburaka_staff.keys()):
				staff_count = magburaka_staff[str(day)]
				staff_count_magburaka_prev = staff_count
			else:
				staff_count = staff_count_magburaka_prev
			sys.stdout.write("\tMagburaka: \t" + str(staff_count) + "\t")

		day_obj["centers"][center["name"]].update({"staff_count": staff_count})

	## And end with the WHO data by country
	death_total = 0
	cases_total = 0
	i = 0
	while i < len(countries):
		country = countries[i]
		i += 1

		filename = country +".csv"
		file_csv = open(filename, "rb")
		table_file = csv.reader(file_csv)

		value_cases = 0
		value_deaths = 0

		closest_lower_bound = utils_ebola.find_closest_date(day, filename, 1, "lower")
		closest_upper_bound = utils_ebola.find_closest_date(day, filename, 1, "upper")
		
		if (closest_upper_bound["numrow"] == -1):
			closest_upper_bound = closest_lower_bound

		if (closest_lower_bound["numrow"]>0):
			file_csv.seek(0)
			lower_bound_row = next(itertools.islice(table_file, closest_lower_bound["numrow"], None))
			file_csv.seek(0)
			upper_bound_row = next(itertools.islice(table_file, closest_upper_bound["numrow"], None))

			steps = abs(closest_upper_bound["numday"] - closest_lower_bound["numday"]) + 1
			#days from lowerbound
			numday = day - closest_lower_bound["numday"]

			#computes cases
			value_cases = utils_ebola.evolution(lower_bound_row[2], upper_bound_row[2], steps, numday)
			#computes deaths
			value_deaths = utils_ebola.evolution(lower_bound_row[3], upper_bound_row[3], steps, numday)

			cases_total += value_cases
			death_total += value_deaths

		day_obj["regional_data"].update({country: {"cases":int(value_cases), "deaths": int(value_deaths)}})

	day_obj["regional_data"].update({"cases_total": int(cases_total), "death_total": int(death_total)})

	json_data.update({date: day_obj})

## Now, we compute the new cases by week and by country
i = 0
while i < len(countries):
	
	country = countries[i]
	i += 1

	cases_prev = 0
	new_cases = 0

	for day in range(0,last_day):
		# increment the unix timestamp
		date = start_date + day * 86400

		if date % 7 == 0:
			#new week!

			monday_cases = json_data[date]["regional_data"][country]["cases"]
			new_cases = monday_cases - cases_prev
			cases_prev = monday_cases

		json_data[date]["regional_data"][country].update({"weekly_new_cases": int(new_cases)})

with open('../src/assets/json/days.json', 'w') as outfile:
    json.dump(json_data, outfile)


with open('../src/assets/json/centers.json', 'w') as outfile:
    json.dump(centers, outfile)