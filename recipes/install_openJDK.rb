

bash "instal Open JDK" do
  user node['cloudfoundry_common']['user']
  cwd  File.join(node['cloudfoundry_common']['vcap']['install_path'], "cloud_controller")
  code "apt-get install openjdk-6-jdk"
  action :run
end
