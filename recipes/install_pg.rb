
gem_package("pg") do
#  gem_binary("/opt/ree/bin/gem")
  options("--no-ri --no-rdoc")
   ignore_failure true

action :install
end


