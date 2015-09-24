## Connect to bGrid using pgAdmin3
To connect to the BGrid server, type the following into your unix terminal:
`ssh -p 5022 username@bgrid.lbl.gov`

To set up a tunnel so that PGAdminIII can connect to the bgrid server:
`ssh -p 5022 username@bgrid.lbl.gov -L 5433:localhost:5432`

If you'd prefer this to quietly run in the background, so that you can still use terminal, you can add the -f (background) and -N (non-verbose) commands:
`ssh -f emunsing@bgrid.lbl.gov -L 5433:localhost:5432 -N`
