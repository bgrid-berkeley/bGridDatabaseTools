# Adding a New User to the Database 
## RSA Key Creation
Ask user to generate RSA Key ans set up a github account.  Instructions are here. 
https://help.github.com/articles/generating-ssh-keys/

User must send administrator 
* contents of the id_rsa.pub file in their .ssh directory, and
* desired username

## Set up a user account on the server
### Create username
Server will prompt you to add the actual name of the user and for other information. Include the user's email address under "other" 
```bash
sudo adduser [username]
```

### Add RSA key
* ``su`` into the new user's account (this is important so that the user "owns" their own files).  
* ``cd'' into the users home directory.
* create a directory called ``.ssh``, 
* add a file called ``authorized_keys``,
*  add the contents of the id_rsa.pub file to one line of ``authorized_keys''. 
```bash
sudo su [username]
cd ~
mkdir .ssh
nano .ssh/authorized_keys
``` 
I use nano to edit the authorized keys file. Simply add each key on a new line of the file. Use ``ctrl+o`` to write the file out and ``ctrl+x`` to exit.  This must be edited from the new user's account for the permissions to be correct (hence the ``su`` step).  

### Allow the user ssh access
We configure ssh such that only an explicit list of users can have remote ssh access. You can add the user to this list by using nano to edit the ssh configuration file. The configuration file is ``/etc/ssh/sshd_config``, the list is on line 29.
``` 
sudo nano /etc/ssh/sshd_config
```


The user should now be able to ssh into the server using the command
```ssh [username]@bgrid.lbl.gov -p ****```

## Give the user a postgres account
Login to postgres, create a user, and add them to appropriate groups
```SQL
CREATE ROLE username WITH LOGIN, PASSWORD  '[makepasswordhere]';
GRANT bgrid to username;
```
