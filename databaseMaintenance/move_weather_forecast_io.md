## Create a schema
from psql
```sql
CREATE SCHEMA weather_forecastio AUTHORIZATION bgrid;
```

## Copy databases
From the bash, copy the databases using this handy tool from stackexchange

```bash
pg_dump -U mtabone -t dailyData weather_forecastio | psql -U mtabone -d bgrid.weather_forecastio
```