# Chef Provisioning Proof Of Concept

The following is a proof of concept to deploy multiple machines and configure them using the Chef configuration and automation platform.  I've used chef-provisioning that is a framework for implementing 'Infrastructure As Code' which allows us to make use of this same codebase in development, staging and production environments.  In development, we can use Vagrant, in staging, perhaps a private cloud platform such as VMWare vSphere and onto production in Amazon Web Services.

The Concept
-----------

We'll provision a http based golang app onto 2 app servers and a nginx web server that will load balance http requests to the 2 app servers.

Prerequisites
-------------
You'll need the following software installed:

- Vagrant https://www.vagrantup.com/
- Oracle VirtualBox 5.0.8 https://www.virtualbox.org/
- ChefDK 0.10 https://downloads.chef.io/chef-dk

> NOTE: This test was built on a Mac and has not been tested on other
> platforms, however one of Vagrant's benefits is building cross
> platform development environments so if all prerequisites are met,
> this test should run without fail.

Here are the versions of various Chef components I have:
```
chef --version
Chef Development Kit Version: 0.10.0
chef-client version: 12.5.1
berks version: 4.0.1
kitchen version: 1.4.2
```
Installation
------------

1. Clone this repository using:
 
        git clone https://github.com/danny-waite/provtest.git       

2. Change directory to the provtest directory

        cd provtest

Running Tests
-------------
We're making using of test kitchen to run various tests on our chef recipes. To verify our implementation run the following to create, converge, setup, verify and finally destroy the test environment. 

    kitchen test

The output should look like the following:
```
Process "app"
  should be running
       
Port "8484"
  should be listening

Package "nginx"
  should be installed

Service "nginx"
  should be enabled
  should be running

Port "80"
  should be listening

Host "localhost"
  should be reachable

Finished in 0.17826 seconds (files took 0.26893 seconds to load)
7 examples, 0 failures
```

Provisioning the System
-----------------------

Now for the the fun bit, to deploy the system.  To do this, run the following:

`chef-client -z -o "provtest::vagrant,provtest::cluster"`

Once the command completes you can test the platform using the following command:

`./test_cluster.sh`

You should see an output similar to:
```
Hi there, I'm served from app1!
Hi there, I'm served from app2!
Hi there, I'm served from app1!
Hi there, I'm served from app2!
Hi there, I'm served from app1!
```

Cleaning Up
-----------

I wrote a destroy recipe but it seems not to work, didn't quite have time to debug it.

`chef-client -z cookbooks/provtest/recipes/vagrant.rb cookbooks/provtest/recipes/destroycluster.rb`

I found that doing the following works most of the time:

`rm -rf nodes/ clients/`

and then:
```
vagrant global-status
vagrant destroy -id-
```

Some Notes and Considerations
-----------------------------

1. I had planned to make use of the nginx cookbook from the Chef Supermarket for various reasons such as its ability to providing a platform agnostic wrapper around nginx.

2. My target platform has been Ubuntu for time, my nginx configuration could have issues on other platforms.

3. I was planning to run the serverspec tests once the provisioning part was complete, and as such made various provisions for this, however it was a little tougher than expected so this part was omitted.

4. It would have been quite easy to add an attribute to be able to scale to more app servers, and I made provisions to so, however I opted for simplicity and readability, particularly in the development stage.

5. During development I found a bug where if no vagrant boxes exist on your machine the provisioning stage could fail, to fix this simply run 'vagrant box add hashicorp/precise64'

6. I note a difference in the Ubuntu versions between the test kitchen version and the provisioning version, I've kept this as-is for speed, however this should be changed in the future.
