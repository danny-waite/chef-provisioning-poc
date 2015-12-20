# the cluster provisioning recipe, idea was to keep this platform agnostic however for speed
# I included vagrant specific options here, should seperate out in future

machine 'app1' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.2"'].join("\n")
	recipe 'apt'
	recipe 'provtest::appnode'

end

machine 'app2' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.3"'].join("\n")
	recipe 'apt'
	recipe 'provtest::appnode'
	
end

machine 'web' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.100"'].join("\n")
	recipe 'apt'
	recipe 'provtest::webnode'
	attribute ['provtest', 'appnodes'], ["192.168.100.2", "192.168.100.3"]

end	
