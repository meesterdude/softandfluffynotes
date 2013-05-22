set_default :ruby_version, "1.9.3"

namespace :rvm do
  desc "Install rvm, Ruby, rubygems, bundler"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install git-core build-essential openssl"\
      " libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev"\
      " libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf"\
      " libc6-dev ncurses-dev automake libtool bison subversion"
    run "curl -L get.rvm.io | bash -s stable"
    run "source ~/.rvm/scripts/rvm"
    run "rvm install 1.9.3"
    run "rvm user 1.9.3 --default"
    run "rvm rubygems current"
    run "gem install bundler --no-ri --no-rdoc"
  end
  after "deploy:install", "rvm:install"
end
