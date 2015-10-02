# RASS data
Data in this shema result from the 2009 California Residential Appliance Saturation Survey and a susequent conditional demand analysis (CDA), commissioned by the California Energy Commission.  The consulting group KEMA -- in conjunction with the utilities PG&E, SCE, SDG&E and LADPW --  designed and implemented the survey and performed the subsequent CDA. 
A full writeup of methods and results can be found here: [http://www.energy.ca.gov/appliances/rass/](http://www.energy.ca.gov/appliances/rass/). 

# survdata and surfdata 
Cleaned variables from the California's Residential Appliance Saturation Survey (RASS), and estimates of ``unit energy consumption'' from individual appliances in each household.  A Full explanation of this process is included in Volume one of the official survey report, available here: [http://www.energy.ca.gov/appliances/rass/](http://www.energy.ca.gov/appliances/rass/)

A "conditional demand analysis'' (CDA) is used to find the unit energy consumption (UEC). 
* UEC is defined by an engineering estimate of energy use for each appliance, multipled by a "scaling factor." 
* There is one scaling factor for each type of appliance. Thus variation in UAE results from appliance ownership and the housing stock, but not from the individual habits of each repondent. 
* Scaling factors are identified by regrgressing ``normalized monthly energy use'' of each house onto the engineering estiamtes of appliance energy use for each appliance in the house. 
* Sampling for the RASS survey results from a stratified weighted sample, and regressions are weighted appropriately to represent each startum's representativeness of the population, which is defined as all users served by the participating utilities --- LADPW, PG&E, SDG&E, SCE. 
* Normalized Annual Consumption for each house is the predicted energy consumption during a standard weather profile. This is identified for each house separately using a Princeton Scorekeeping Model (PRISM). 
