## Connect to bGrid using pgAdmin3
#### To connect to the BGrid2 server, type the following into your unix terminal:
`ssh -p 5022 username@bgrid2.dyn.berkeley.edu`

#### To set up a tunnel so that pgAdmin3 can connect to the bgrid2 server:
`ssh -f username@bgrid2.dyn.berkeley.edu -p 5022 -L 5435:localhost:5432 -N`

#### Then you need to configure a new connection in the pgAdmin3 interface: 
The host is the localhost because you tunneled (127.0.0.1) and the port is the port on your computer that you tunneled from (5435 as written above). Your username and password and access privliges must be set up beforehand. 
