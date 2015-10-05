## Storing passwords as environment variables
Often our programs will need passwords to access databases or other servers (e.g., your PostgreSQL password, github password). Writing passwords directly into the program text itself is poor form, it could accidentally get uploaded to github, be broadcast on a website, or otherwise be more easily accessed by a hacker. 

We can be more secure (though not incredibly secure) by storing our passwords as environment variables that are only available when your username accesses the server. Passwords can be stored temporarily (just for the duration of your shell session) by using the ``export`` command directly from the terminal, such as ``export VARNAME=value`` but this setting will be lost when your session ends. To permanently store passwords, you save them in your personal ``~/.bashrc`` file which is run everytime you login.

### ~/.bashrc
You can edit the .bashrc file using a command line text editor like 'nano,' or you can ftp it to and from the server using an ftp client. 
```bash
nano ~/.bashrc
```


For each password you'd like to save as an environment variable, add the following line to your ``~/.bashrc`` file,  below is an example for Github 
```bash
export GITHUB_USERNAME=your_github_username
export GITHUB_PASSWORD=your_github_passwrd
```

[A more thorough explanation of environment variables](http://cbednarski.com/articles/understanding-environment-variables-and-the-unix-path/) can be found at the link.

### ~/.Renviron
UPDATE!  Rstudio-server will not execute your .bashrc file before running. Thus your environment variable will not be accessible from Rstudio.

Instead, R will execute the file ``.Renviron`` located in your home directory. The syntax for setting an environment variable here is similar, but without the ``export command``. 

For example, if your ``~/.Renviron`` contains 
```bash
GITHUB_USERNAME=your_github_username
GITHUB_PASSWORD=your_github_passwrd
```

Then from R you can access these environment variables using this syntax
```R
githubuser <- Sys.getenv('GITHUB_USERNAME')
githubpass <- Sys.getenv('GITHUB_PASSWORD')
```
