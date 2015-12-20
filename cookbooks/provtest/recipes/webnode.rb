package 'nginx' do
  action :install
end

template '/etc/nginx/sites-available/default' do
	source 'default.erb'
	mode '0644'
end

link '/etc/nginx/sites-enabled/default' do
  to '/etc/nginx/sites-available/default'
end

service 'nginx' do
  action [ :enable, :restart ]
end