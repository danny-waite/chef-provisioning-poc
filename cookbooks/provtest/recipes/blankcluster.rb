# blank cluster used to quickly get a test environment without running any recipes

machine 'app1' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.2"'].join("\n")
end

machine 'app2' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.3"'].join("\n")
	
end

machine 'web' do
	add_machine_options :vagrant_config => ['config.vm.network "private_network", ip: "192.168.100.100"'].join("\n")
	attribute ['provtest', 'appnodes'], ["192.168.100.2", "192.168.100.3"]
end	
