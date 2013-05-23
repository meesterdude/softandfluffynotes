set_default(:mysql_host, "localhost")
set_default(:mysql_user) {application}
set_default(:mysql_password) { Capistrano::CLI.password_prompt "Mysql Password for #{application} user: " }
set_default(:mysql_database) { "#{application}_production" }

namespace :mysql do
  desc "Install Mysql"
  task :install, roles: :db, only: {primary: true} do
    pass = Capistrano::CLI.password_prompt "Enter root database password: "
    run "#{sudo} apt-get -y install mysql-server" do |channel, stream, data|
      channel.send_data("#{pass}\n\r") if data =~ /password/
    end
  end
  after "deploy:install", "mysql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    mysql_admin_user =  Capistrano::CLI.ui.ask "MYSQL admin user:"

    sql = <<-SQL
    CREATE DATABASE IF NOT EXISTS #{mysql_database};
    GRANT ALL PRIVILEGES ON #{mysql_database}.* TO #{mysql_user}@localhost IDENTIFIED BY '#{mysql_password}'
    SQL
    run %Q{mysql --user=#{mysql_admin_user} -p --execute="#{sql}"} do |channel, stream, data|
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
