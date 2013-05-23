Deploying
=========

1.  Login to server, "adduser <user> --ingroup sudo"
2.  From repo, run "cap deploy:install"
3.  Then run "cap deploy:setup"
    At some point you'll be prompted to enter a new postgresql password for the
    app's user.
4.  Finally run "cap deploy:cold"
5.  ???
6.  Profit.
