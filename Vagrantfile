#!/usr/bin/env ruby

Vagrant.configure('2') do |config|

  config.vm.hostname = 'projector'
  config.vm.box = ENV['VAGRANT_BOX'] || 'opscode_ubuntu-12.04_chef-11.2.0'
  config.vm.box_url = ENV['VAGRANT_BOX_URL'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/#{config.vm.box}.box"
  config.berkshelf.enabled = true

  config.vm.provision :shell do |shell|
    shell.inline = 'test -f $1 || (sudo apt-get update -y && touch $1)'
    shell.args = '/var/run/apt-get-update'
  end

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = './data'
    chef.run_list = [
      'recipe[jenkins::server]',
      'recipe[projector::default]'
    ]
  end
end
