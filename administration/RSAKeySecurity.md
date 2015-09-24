## Checklist for security
1. Make sure that files/directories ON YOUR MACHINE are readable and writable only by you
      - ~/.ssh
      - ~/.ssh/id_rsa   
      - ~/.bashrc and ~/.bash_profile (if they exist; for environment variables)

2. Make sure that files in your directory on the remote machine are read and write only by you 
      - ~/.ssh
      - ~/.ssh/authorized_keys
      - ~/.bashrc

## How to check and change the read/write privileges of a file 
- `ls -l path/to/file` lists all privileges of a file 
- `chmod 600 path/to/file` changes privileges of a file or directory to be readable/writable only by you 
- `chmod 700 path/to/file` makes a file or directory read/write/executable only by you. "Executable" for a directory mean has access to see its contents. 

Example output of 'ls -l' 
```bash
michaelangelo@EMAC3U:~$ ls -l ~/.ssh/authorized_keys 
-rwxrw-r-- 1 michaelangelo root 856 Feb 16 12:15 /home/michaelangelo/.ssh/authorized_keys
```

The security here is poor, authorized_keys should only be read/writable by the owner. 
Instead, the initial `rwx` signify that the file is read/write/executable by the owner, the middle `rw-` signifies that it is readable/writeable by the group but not executable, and the final `r--` signifies that it is readable by anyone on the computer. 

The following line uses `chmod` to change the permissions, and then checks the permissions to be sure that they're changed so that only the owner can read/write the file, and no one else can view it. 
```bash
michaelangelo@EMAC3U:~$ chmod 600 ~/.ssh/authorized_keys 
michaelangelo@EMAC3U:~$ ls -l ~/.ssh/authorized_keys 
-rw------- 1 michaelangelo root 856 Feb 16 12:15 /home/michaelangelo/.ssh/authorized_keys
```

A handy tutorial for more information is here: http://www.perlfect.com/articles/chmod.shtml
