def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end
def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end
namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install software-properties-common make"
  end
end

namespace :housekeeping do
  desc "Move public/production_index.html to public/index.html"
  task :rename_production_index, roles: :app do
    run "mv #{current_path}/public/production_index.html #{current_path}/public/index.html"
  end
end
after "deploy", "housekeeping:rename_production_index"
after "deploy:cold", "housekeeping:rename_production_index"
