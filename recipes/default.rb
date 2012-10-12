#
# Cookbook Name:: cloudfoundry-cloud_controller
# Recipe:: default
#
# Copyright 2012, Trotter Cashion
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if Chef::Config[:solo]
	Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else 
	
	
	node.set['cloudfoundry_cloud_controller']['database']['host'] = node['ipaddress']
        cf_id_node = node['cloudfoundry_cloud_controller']['cf_session']['cf_id']
  	m_nodes_nats = search(:node, "role:cloudfoundry_nats_server AND cf_id:#{cf_id_node}")
        
       m_nodes_nats.each {|k| 
        if (k['nats_server']['cf_session']['cf_id'] == node['cloudfoundry_cloud_controller']['cf_session']['cf_id']) then 
	    node.set['searched_data']['nats_user']= k['nats_server']['user']
  	    node.set['searched_data']['nats_password']= k['nats_server']['password']
	    node.set['searched_data']['nats_host']= k['ipaddress']
  	    node.set['searched_data']['nats_port']= k['nats_server']['port']
        end
       }





	m_nodes_dea = search(:node, "role:cloudfoundry_dea_* AND cf_id:#{cf_id_node}")
	tmp = Hash.new

	m_nodes_dea.each do |m_node_dea|
	tmp = tmp.merge(m_node_dea['cloudfoundry_dea']['runtimes'])
	end

	Chef::Log.warn("runtimes.merge(tmp['runtimes']" + tmp.to_s)
	node.set['searched_data']['runtimes']= tmp

end 

include_recipe "java"
include_recipe "cloudfoundry-cloud_controller::install_blobstore_client"
include_recipe "cloudfoundry-cloud_controller::install_pg"
include_recipe "cloudfoundry-cloud_controller::database"
include_recipe "cloudfoundry-cloud_controller::server"
