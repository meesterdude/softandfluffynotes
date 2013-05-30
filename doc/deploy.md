Deploying
=========

Initial Deployment
------------------

1.  Login to your production server and create a new user with sudo priveleges.  This user
    is used to run all installation steps and the app itself. 
    
    "adduser `user` --ingroup `sudo`"

2.  Log out of the production server and edit your local repository's deploy.rb config file. 
    Set the username to the user you just created, make sure the git url and branch are the
    ones you want deployed.

3.  You're ready to install.  From the root of your local repo, run:

    "cap deploy:install"

    The first prompt will ask you for your deploying user's password.  It will then run through
    all of the installation steps for rbenv, postgresql, nginx, and unicorn.

3.  Now run "cap deploy:setup"

    This will run through configuring nginx, postgresql, and unicorn.  You will be prompted to
    create a new postgresql password for the app's user.  This password will be stored in the
    app's database.yml file.

4.  Finally run "cap deploy:cold"
    
    This will deploy the app, run any pending migrations, and invoke deploy:start.  The app should
    be running after this step.

Subsequent Deployments
----------------------

Running "cap deploy" should take care of these.
