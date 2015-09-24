# Connect to R-studio Server on bGrid
## This is a simple 3-step process
1. Set up an ssh tunnel to switch-db1 (one command in terminal)
2. Open up rstudio in your browser window. 
3. Update a handy list of packages you've installed below. 

You need an account on db1 to do this. Let MT know if you need one. 

## Set up the ssh tunnel
This is a simple command to make a port on your computer communicate with a port on a remote server. 
In this case we're going to make the port 8789 on your computer communicate with the rstudio-server port on bgrid (8787). 

```bash
ssh -f yourusername@bgrid.lbl.gov -p **** -L 8789:localhost:8787 -N
```

You'll notice that this command is very similar to a normal ssh command with a few extra options. `-L` is the key one which binds 8789 on your computer (localhost) to 8787 on the remote machine.  `-f` tells the process to run in the background and not bother you.  This shouldn't be a problem as the tunnel itself does not require resources. Finally `-N` tells ssh that you won't be needing to run any commands on the remote machine through the terminal. 

Source: http://www.revsys.com/writings/quicktips/ssh-tunnel.html

## Load rstudio in any browser. 
Now we can access rstudio on the remote machine in any browser. 
Just use the web-address `localhost:8789`

You will need your username and password for bGrid to log into Rstudio server 
