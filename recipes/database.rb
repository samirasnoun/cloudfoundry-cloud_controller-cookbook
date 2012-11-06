
node.set['cloudfoundry_common']['cf_session']['cf_id'] = node['cloudfoundry_cloud_controller']['cf_session']['cf_id']


include_recipe "cloudfoundry-common"

include_recipe "postgresql::server"

postgresql_database node['cloudfoundry_cloud_controller']['database']['name'] do
  connection ({:host => "127.0.0.1", :port => 5432, :username => 'postgres', :password => node['postgresql']['password']['postgres']})
  action :create
end
