import csv

def evolution(y1, y2, steps, x):
	return float(y1) + (float(y2) - float(y1)) * (float(x)/float(steps))

def find_closest_date(day, csv_file, col_date, bound):
	# bound = upper means next date ; lower = prev date
	# returns the number of the line which is closest
	
	closest_date = -1
	num_row = 0
	distance_prev = -1
	row_to_return = -1

	file_csv = open(csv_file, "rb")
	table = csv.reader(file_csv)
	table_list = list(table)

	file_csv.seek(0)

	for row in table:
  		
  		date = row[col_date]
  		distance = -1

  		if (date != "" and date != "Day"):
	  		if (bound == "upper"):
	  			if (int(date) >= day):
		  			distance = abs(int(date) - day)
		  	elif (bound == "lower"):
		  		if (int(date) <= day):
			  		distance = abs(day - int(date))

	  	if distance_prev == -1:
	  		distance_prev = distance

	  	if distance <= distance_prev and distance >= 0:
	  		row_to_return = num_row

  		num_row += 1

  	return {"numrow": row_to_return, "numday":int(table_list[row_to_return][col_date])}