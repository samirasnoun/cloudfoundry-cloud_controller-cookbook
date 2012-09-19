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
	m_nodes_nats = search(:node, "role:cloudfoundry_nats_server")
	m_node_nats = m_nodes_nats.first
	if m_nodes_nats.count > 0 
	    node.set['searched_data']['nats_user']= m_node_nats.nats_server.user
  	    node.set['searched_data']['nats_password']= m_node_nats.nats_server.password
	    node.set['searched_data']['nats_host']= m_node_nats.ipaddress
  	    node.set['searched_data']['nats_port']= m_node_nats.nats_server.port
	end
	m_nodes_dea = search(:node, "role:cloudfoundry_dea*")
	tmp = Hash.new

	m_nodes_dea.each do |m_node_dea|
	tmp = tmp.merge(m_node_dea[:cloudfoundry_dea][:runtimes])
	end

	Chef::Log.warn("runtimes.merge(tmp['runtimes']" + tmp.to_s)
	node.set['searched_data']['runtimes']= tmp
end 


include_recipe "cloudfoundry-cloud_controller::install_blobstore_client"
include_recipe "cloudfoundry-cloud_controller::install_pg"
include_recipe "cloudfoundry-cloud_controller::database"
include_recipe "cloudfoundry-cloud_controller::server"
