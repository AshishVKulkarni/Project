The	overall	goal	of	the	case	is	to	provide	actionable	insight,	based	on	the	data	available,	as	well	as	accurately	predict	which	people	(customers) will	be	expensive.
The	dataset	contains	healthcare cost	information from	an	HMO	(Health	Management Organization). 
Each row	in	the	dataset	represents a	person.	

The goal was to	understand the key drivers:

• Predict	people	who	will	spend	a	lot	of	money	on	health	care	next	year	(i.e.,	which
people	will	have	high	healthcare	costs).  
• Provide	actionable	insight	to	the	HMO,	in	terms	of	how	to	lower	their	total	health
care	costs,	by	providing	a	specific	recommendation	on	how	to	lower	health	care
costs.

#### Metadata
• X:	Integer,	Unique	identified	for	each	person  
• age:	Integer,	The	age	of	the	person	(at	the	end	of	the	year).  
• location:	Categorical,	the	name	of	the	state (in	the	United	States) where	the	person
lived	(at	the	end	of	the	year)  
• location_type:	Categorical,	a	description	of	the	environment	where	the	person	lived
(urban	or	country).  
• exercise:	Categorical,	“Not-Active”	if	the	person	did	not	exercise	regularly	during
the	year,	“Active”	if	the	person	did	exercise	regularly	during	the	year.  
• smoker:	Categorical,	“yes”	if	the	person	smoked	during	the	past	year,	“no”	if	the
person	didn’t	smoke	during	the	year.  
• bmi:	Integer,	the	body	mass	index	of	the	person.	The	body	mass	index	(BMI)	is a
measure	that	uses	your	height	and	weight	to	work	out	if	your	weight	is	healthy.  
• yearly_physical:	Categorical,	“yes”	if	the	person	had	a	well	visit	(yearly	physical)
with	their	doctor	during	the	year.	“no”	if	the	person	did	not	have	a	well	visit	with
their	doctor.  
• Hypertension: “0”	if	the	person	did	not	have	hypertension.  
• gender:	Categorical,	the	gender	of	the	person  
• education_level: Categorical,	the	amount	of	college	education	("No	College	Degree",
"Bachelor",	"Master",	"PhD")  
• married: Categorical,	describing	if	the	person	is	“Married” or	“Not_Married”
• num_children:	Integer,	Number	of	children  
• cost:	Integer,	the	total	cost	of	health	care	for	that	person,	during	the	past	year.  

Data:
The	data	file	is	located	at:
							https://intro-datascience.s3.us-east-2.amazonaws.com/HMO_data.csv
