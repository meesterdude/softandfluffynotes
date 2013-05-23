namespace :nginx do
  task :setup do
    template "nginx_passenger.erb", "/tmp/nginx_site_conf"
    run "#{sudo} mv /opt/nginx/conf/nginx.conf /opt/nginx/conf/nginx.conf.bak"
    template "nginx.conf.erb", "/tmp/nginx_main_conf"
    run "#{sudo} mv /tmp/nginx_main_conf /opt/nginx/conf/nginx.conf"
    run "#{sudo} mkdir -p /opt/nginx/sites-enabled"
    run "#{sudo} mkdir -p /opt/nginx/sites-available"
    run "#{sudo} mv /tmp/nginx_site_conf /opt/nginx/sites-enabled/#{application}"
    #run "#{sudo} rm -f /opt/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  # nginx commands
  %w[start stop restart].each do |command|
    task command do
      run "#{sudo} service nginx #{command}"
    end
  end
end
