# an attempt to 

require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'

machine 'app1' do
  :destroy
end

machine 'app2' do
  :destroy
end
 
machine 'web' do
  :destroy
end