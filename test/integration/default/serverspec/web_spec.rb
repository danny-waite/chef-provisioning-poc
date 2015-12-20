require 'spec_helper'

describe package("nginx") do
  it { should be_installed }
end

describe service("nginx") do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

# initialise app server list as localhost to be safe
servers = ["localhost"]

# If the servers file exists, read that into server list
if File.exists?("/tmp/servers")
	servers = IO.readlines("/tmp/servers").map(&:chomp)
end

# check to see if each app server is up
servers.each do |server|
	describe host(server) do
	  it { should be_reachable.with( :port => 8484 ) }
	end
end
