namespace :passenger do
  task :install do
    run "gem install passenger --no-rdoc --no-ri"
    run "#{sudo} apt-get install -y libcurl4-openssl-dev"

    # this gets ugly
    input = ''
    run "rvmsudo passenger-install-nginx-module" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(Capistrano::CLI.password_prompt("Password for '#{user}': ") + "\n") if data =~ /password/
      channel.send_data(input = $stdin.gets) if data =~ /(Enter|ENTER|Please|specify)/
    end

    run "#{sudo} mv /opt/nginx/conf/nginx.conf /opt/nginx/conf/nginx.conf.bak"
    template "nginx.conf.erb", "/tmp/nginx_main_conf"
    run "#{sudo} mv /tmp/nginx_main_conf /opt/nginx/conf/nginx.conf"
    run "#{sudo} mkdir -p /opt/nginx/sites-enabled"
    run "#{sudo} mkdir -p /opt/nginx/sites-available"

    run "wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh"
    run "#{sudo} mv init-deb.sh /etc/init.d/nginx"
    run "#{sudo} chmod +x /etc/init.d/nginx"
    run "#{sudo} /usr/sbin/update-rc.d -f nginx defaults"
  end
  after "deploy:install", "passenger:install"
end
