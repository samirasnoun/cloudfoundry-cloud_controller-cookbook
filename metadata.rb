maintainer       "Trotter Cashion"
maintainer_email "cashion@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures cloudfoundry-cloud_controller"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"
depends "cloudfoundry"
%w{ ubuntu }.each do |os|
  supports os
end

%w{ java postgresql postgresql_cc mysql database cloudfoundry-common cloudfoundry-cloud_controller deployment}.each do |cb|
  depends cb
end
