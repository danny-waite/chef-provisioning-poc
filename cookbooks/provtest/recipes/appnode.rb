# the app node recipe

include_recipe "golang::default"

directory "/opt/go/code/" do
  owner "root"
  group "root"
  recursive true
end

cookbook_file "/opt/go/code/app.go" do
  source "app.go"
  owner "root"
  group "root"
end

# build the app
execute "/usr/local/go/bin/go build app.go" do
  cwd "/opt/go/code/"
  creates "/opt/go/code/app"
end

# should use supervisor, upstart etc. using nohup for speed
service "appservice" do
  supports :start => true
  start_command 'nohup /opt/go/code/app &'
  action :start
end

# write the appnodes attribute to a file ready for tests
file "/tmp/servers" do
  content node['provtest']['appnodes'].join("\n") 
  owner "root"
  group "root"
  mode 00600
end