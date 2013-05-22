set_default(:mysql_host, "localhost")
set_default(:mysql_user) {application}
set_default(:mysql_password) { Capistrano::CLI.password_prompt "Mysql Password for #{application} user: " }
set_default(:mysql_database) { "#{application}_production" }

namespace :mysql do
  desc "Install Mysql"
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} apt-get -y install mysql-server"
    run "#{sudo} /usr/bin/mysql_install_db"
    run "#{sudo} /usr/bin/mysql_secure_installation"
  end
  after "deploy:install", "mysql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    set(:mysql_admin_user) { Capistrano::CLI.ui.ask "MYSQL admin user:" }

    sql = <<-SQL
    CREATE DATABASE #{mysql_database};
    GRANT ALL PRIVELEGES ON #{mysql_database}.* TO #{mysql_user}@localhost IDENTIFIED BY '#{mysql_password}'
    SQL
    run %Q{#{sudo} --user=#{mysql_user} -p --execute="#{sql}"} do |channel, stream, data|
      if data =~ /^Enter password:/
        pass = Capistrano::CLI.password_prompt "Enter database password for '#{mysql_admin_user}': "
        channel.send_data "#{pass}\n"
      end
    end
  end
  after "deploy:setup", "mysql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mysql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "mysql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"
end
