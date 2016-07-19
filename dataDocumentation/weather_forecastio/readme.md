# weather_forecastio
This shema stores data that were downloaded from the [ForecastIO API](http://forecast.io). I've written R scripts to automate the dowloading and uploading, they're stored in this repository under [databaseTools/pgFOrecastIO](../../databaseTools/pgForecastIO). ForecastIO profides daily and hourly summary data>

All data from the pgForecastIO program are contained in three tables
- locations: stores all locations for which we have data, and provides a unieuq LocID. 
- dailyData: contains daily data, locations are identified by lodID, days are provided a unique dayID. 
- hourlyData: contains hourly data, each row is identified by dayID, locID, and hourID. 

There is a fourth table that is an invention of Eric Munsing: summary_data. I'm not sure what's in here, but it looks like summary statistics for each location in the database.




