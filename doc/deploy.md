Deploying
=========

Initial Deployment
------------------

1.  Login to your production server and create a new user with sudo priveleges.  This user
    is used to run all installation steps and the app itself. 
    
    "adduser `username` --ingroup `sudo`"

    Depending on your vps, there may be a different groupname for elevated priveleges.    

2.  Log out of the production server and copy your local repository's `config/deploy.rb.example`
    to `config/deploy.rb`.
    
    "cp config/deploy.rb.example config/deploy.rb"

3.  Edit `deploy.rb`, set username and server location.  Make sure the repository and branch
    parameters are what you want.

    ```ruby
    # ...
    
    server "localhost", :web, :app, :db, primary: true # change localhost to your server

    set :application, "softandfluffynotes"
    set :user, "some_user" # change some_user to the user you created in step 1
    # ...
    
    # make sure these are set to the proper repo and branch you're deploying
    set :repository, "git@github.com:meesterdude/#{application}.git"
    set :branch, "master"
    
    # ...
    ```

4.  You're ready to install.  From the root of your local repo, run:

    "cap deploy:install"

    The first prompt will ask you for your deploying user's password.  It will then run through
    all of the installation steps for rbenv, postgresql, nginx, and unicorn.

5.  Now run "cap deploy:setup"

    This will run through configuring nginx, postgresql, and unicorn.  You will be prompted to
    create a new postgresql password for the app's user.  This password will be stored in the
    app's database.yml file.

6.  Finally run "cap deploy:cold"
    
    This will deploy the app, run any pending migrations, and invoke deploy:start.  The app should
    be running after this step.

Subsequent Deployments
----------------------

Running "cap deploy" should take care of these.
