# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
    
  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.synced_folder "salt", "/srv/salt"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
    salt.bootstrap_options = "-g https://github.com/saltstack/salt.git -P"
    salt.install_type = "git"
    salt.install_args = "v2014.7.0rc2"
  end  
end
