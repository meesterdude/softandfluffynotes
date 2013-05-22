namespace :passenger do
  task :install do
    run "gem install -y --no-rdoc --no-ri passenger"
    run "rvmsudo -p #{sudo_prompt} passenger-install-nginx-module"
  end
  task :setup do
    template "nginx_passenger.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    task command do
      run "#{sudo} service nginx #{command}"
    end
  end
end
