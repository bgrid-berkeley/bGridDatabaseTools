# Backups
Michaelangelo believes he has now scheduled daily backups for bgrid2, which are stored on his computer in SDH (EMAC3U). Backups from the first of each month are stored indefinitely (must be deleted manually by a user if at all), otherwise backups from Fridays are kept for 5 weeks before being deleted, and all other backups are deleted after 7 days. Backup files are in a 4TB hard drive mounted at /media/michaelangelo/bckups2/bgrid_bckups.

# Scripts
Backup scripts are in Michaelangelo's home directory on EMAC3U: /home/michaelangelo/bgrid_bckup_job.
There are two important files: 
 - `pg_backup.config` is a configuration file to sets a location for backups. 
 - `pg_backup_rotated.sh` is a shell file that actually backs up the database. 
 
Both files are adapted from this template: https://wiki.postgresql.org/wiki/Automated_Backup_on_Linux. A line to open an ssh tunnel to the bgrid2 server is added to the configuration file. And all references to `pg_dump` or `pg_dumpall` are edited in the shell file so that they point to the correct psql 9.5 instead 9.3 (/usr/lib/postgresql/9.5/bin/ is added before all references to pg_dump or pg_dumpall). 

To make the script work michaelangelo is set to be the owner of the mounted hard disk and all subfolders leading to the backups. All files should be readable by users on the disk.  

# Automation
To automate backups, the following line is included in michaelangelo's crontab file. 

``0 0 * * * /home/michaelangelo/bgrid_bckup_job/pg_backup_rotated.sh``

This line schedules the shell script to run at mid-night on every day of every month (and excludes no weekdays). It can be accessed by running `crontab -e` from michaelangelo's account on EMAC3U. 
